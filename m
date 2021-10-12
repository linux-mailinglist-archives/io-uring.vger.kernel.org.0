Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883AE42A522
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhJLNNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 09:13:17 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35409 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236680AbhJLNNM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 09:13:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uraoatx_1634044268;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uraoatx_1634044268)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Oct 2021 21:11:09 +0800
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
 <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
Date:   Tue, 12 Oct 2021 21:11:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,


> On 10/12/21 09:48, Xiaoguang Wang wrote:
>> The idea behind register file feature is good and straightforward, but
>> there is a very big issue that it's hard to use for user apps. User apps
>> need to bind slot info to file descriptor. For example, user app wants
>> to register a file, then it first needs to find a free slot in register
>> file infrastructure, that means user app needs to maintain slot info in
>> userspace, which is a obvious burden for userspace developers.
>
> Slot allocation is specifically entirely given away to the userspace,
> the userspace has more info and can use it more efficiently, e.g.
> if there is only a small managed set of registered files they can
> always have O(1) slot "lookup", and a couple of more use cases.

Can you explain more what is slot "lookup", thanks. For me, it seems that

use fd as slot is the simplest and most efficient way, user does not need to

mange slot info at all in userspace.


>
> If userspace wants to mimic a fdtable into io_uring's registered table,
> it's possible to do as is and without extra fdtable tracking
>
> fd = open();
> io_uring_update_slot(off=fd, fd=fd);

No, currently it's hard to do above work, unless we register a big 
number of files initially.

Say we call IORING_REGISTER_FILES to register 1000 files initially,  
then the io_uring

io_file_table only supports 1000 files, fd which is greater than 1000 
will be not able to

be registered.

For safety,  you may need to register the number of 
getrlimit(RLIMIT_NOFILE) initially,

but it also may fail, user may change RLIMIT_NOFILE too. This is why I 
introduce a

io_uring io_file_table resize feature, but I agree this method may waste 
memory, for

example, user app only wants one file registered, but this file's fd is 
very large.


Regards,

Xiaoguang Wang

>
> For the dual wanting an fd both in the normal fdtable and fixed table
> with same indexes, not sure how viable that is but "direct open" can
> be extended if needed.
>
>
>> Actually, file descriptor can be a good candidate slot info. If app 
>> wants
>> to register a file, it can use this file's fd as valid slot, there'll
>> definitely be no conflicts and very easy for user apps.
>>
>> To support to pass fd as slot info, we'll need to automatically resize
>> io_file_table if passed fd is greater than current io_file_table size,
>> just like how fd table extends.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 61 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 53 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 73135c5c6168..be7abd89c0b0 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7768,6 +7768,21 @@ static bool io_alloc_file_tables(struct 
>> io_file_table *table, unsigned nr_files)
>>       return !!table->files;
>>   }
>>   +static int io_resize_file_tables(struct io_ring_ctx *ctx, unsigned 
>> old_files,
>> +                 unsigned new_files)
>> +{
>> +    size_t oldsize = sizeof(ctx->file_table.files[0]) * old_files;
>> +    size_t newsize = sizeof(ctx->file_table.files[0]) * new_files;
>> +
>> +    ctx->file_table.files = kvrealloc(ctx->file_table.files, 
>> oldsize, newsize,
>> +                       GFP_KERNEL_ACCOUNT);
>> +    if (!ctx->file_table.files)
>> +        return -ENOMEM;
>> +
>> +    ctx->nr_user_files = new_files;
>> +    return 0;
>> +}
>> +
>>   static void io_free_file_tables(struct io_file_table *table)
>>   {
>>       kvfree(table->files);
>> @@ -8147,6 +8162,25 @@ static void io_rsrc_put_work(struct 
>> work_struct *work)
>>       }
>>   }
>>   +static inline int io_calc_file_tables_size(__s32 __user *fds, 
>> unsigned nr_files)
>> +{
>> +    int i, fd, max_fd = 0;
>> +
>> +    for (i = 0; i < nr_files; i++) {
>> +        if (copy_from_user(&fd, &fds[i], sizeof(fd)))
>> +            return -EFAULT;
>> +        if (fd == -1)
>> +            continue;
>> +        if (fd > max_fd)
>> +            max_fd = fd;
>> +    }
>> +
>> +    max_fd++;
>> +    if (max_fd < nr_files)
>> +        max_fd = nr_files;
>> +    return max_fd;
>> +}
>> +
>>   static int io_sqe_files_register(struct io_ring_ctx *ctx, void 
>> __user *arg,
>>                    unsigned nr_args, u64 __user *tags)
>>   {
>> @@ -8154,6 +8188,7 @@ static int io_sqe_files_register(struct 
>> io_ring_ctx *ctx, void __user *arg,
>>       struct file *file;
>>       int fd, ret;
>>       unsigned i;
>> +    int num_files;
>>         if (ctx->file_data)
>>           return -EBUSY;
>> @@ -8171,8 +8206,12 @@ static int io_sqe_files_register(struct 
>> io_ring_ctx *ctx, void __user *arg,
>>       if (ret)
>>           return ret;
>>   +    num_files = io_calc_file_tables_size(fds, nr_args);
>> +    if (num_files < 0)
>> +        goto out_free;
>> +
>>       ret = -ENOMEM;
>> -    if (!io_alloc_file_tables(&ctx->file_table, nr_args))
>> +    if (!io_alloc_file_tables(&ctx->file_table, num_files))
>>           goto out_free;
>>         for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
>> @@ -8204,7 +8243,7 @@ static int io_sqe_files_register(struct 
>> io_ring_ctx *ctx, void __user *arg,
>>               fput(file);
>>               goto out_fput;
>>           }
>> - io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
>> + io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, fd), file);
>>       }
>>         ret = io_sqe_files_scm(ctx);
>> @@ -8390,15 +8429,22 @@ static int __io_sqe_files_update(struct 
>> io_ring_ctx *ctx,
>>       struct io_rsrc_data *data = ctx->file_data;
>>       struct io_fixed_file *file_slot;
>>       struct file *file;
>> -    int fd, i, err = 0;
>> +    int fd, err = 0;
>>       unsigned int done;
>>       bool needs_switch = false;
>> +    int num_files;
>>         if (!ctx->file_data)
>>           return -ENXIO;
>>       if (up->offset + nr_args > ctx->nr_user_files)
>>           return -EINVAL;
>>   +    num_files = io_calc_file_tables_size(fds, nr_args);
>> +    if (num_files < 0)
>> +        return -EFAULT;
>> +    if (io_resize_file_tables(ctx, ctx->nr_user_files, num_files) < 0)
>> +        return -ENOMEM;
>> +
>>       for (done = 0; done < nr_args; done++) {
>>           u64 tag = 0;
>>   @@ -8414,12 +8460,11 @@ static int __io_sqe_files_update(struct 
>> io_ring_ctx *ctx,
>>           if (fd == IORING_REGISTER_FILES_SKIP)
>>               continue;
>>   -        i = array_index_nospec(up->offset + done, 
>> ctx->nr_user_files);
>> -        file_slot = io_fixed_file_slot(&ctx->file_table, i);
>> +        file_slot = io_fixed_file_slot(&ctx->file_table, fd);
>>             if (file_slot->file_ptr) {
>>               file = (struct file *)(file_slot->file_ptr & FFS_MASK);
>> -            err = io_queue_rsrc_removal(data, up->offset + done,
>> +            err = io_queue_rsrc_removal(data, fd,
>>                               ctx->rsrc_node, file);
>>               if (err)
>>                   break;
>> @@ -8445,9 +8490,9 @@ static int __io_sqe_files_update(struct 
>> io_ring_ctx *ctx,
>>                   err = -EBADF;
>>                   break;
>>               }
>> -            *io_get_tag_slot(data, up->offset + done) = tag;
>> +            *io_get_tag_slot(data, fd) = tag;
>>               io_fixed_file_set(file_slot, file);
>> -            err = io_sqe_file_register(ctx, file, i);
>> +            err = io_sqe_file_register(ctx, file, fd);
>>               if (err) {
>>                   file_slot->file_ptr = 0;
>>                   fput(file);
>>
>
