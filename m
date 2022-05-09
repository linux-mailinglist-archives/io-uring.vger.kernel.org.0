Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5F520062
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbiEIO7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 10:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiEIO7W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 10:59:22 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF3B7B
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 07:55:28 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r17so9444654iln.9
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yI5akZ3FHaZjQcFhCX038t9SJv2+n2943sJaabuX8J4=;
        b=iZYBrZRSoqa7c+f82c54HWrUqMbKrjHPmcBg5YAExRMEgwCzxnxDMtIG9359nQTulP
         FisahmQ/i8n0w2xPc2bFePMl4E/9ltfW6r8vSI7nheJ3K789AXBH2D8NjBTBTakoCgig
         R0uEGJu/kFpzVrjisMWUkHRS95GzD9kfogaF+sfHPLTItB7hQFUj8qzhJYy5szOSQ7kd
         CaV1bJF6vThUzTToJ2U1Wt8UoWgO7t9z9DuP/JAlAVFqKH0h/ldIpEqFqrZTnIj9dbBb
         hcm9W6Jq/EAO0TmcdmDFQ4mSpnDPSx0jgdEpY27V/0XDB4IWiffWKinRyfKN0Q8dgK42
         EtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yI5akZ3FHaZjQcFhCX038t9SJv2+n2943sJaabuX8J4=;
        b=ovvKvl3jQatc4l1Kq2raB2Z0hJbFdqNuOe5zo2FjnsHk5DHREiwFhsx5KhApt65EgO
         faPc2eQEK7GaR7KI97+5Mldx7snAPmhY/lztgQzFtglB8z6WhvF0oK9Tk2YtZbtxXxn7
         oCOta+HllI6wtpSX385E1z/uii6R6Hukv1iHuwuLvXA5CxlYM6V5WQrsbgCSCLnW3b8C
         0bWuVrNKx9VD/JS6f5kg5wNHvkbcmipF0oF9rtZ91rtIy1MRNgemDiLtz/Qexi5/USiy
         buhsQAsfZAMXhiJuSCLp8J2mYxu1ecUjsFkXvGJinsLqVY0qRsRq8MD09W22DWLBobsH
         DySA==
X-Gm-Message-State: AOAM530kKlHImua626ST+CSaod9wOgxNUbqppFujacvURup6vWl5QnfQ
        JnTrSNPtCJD9AxlZTGbdAGrnY6c/h3MouQ==
X-Google-Smtp-Source: ABdhPJzP2XnGrZuUMsMjOn1cGeI/CGZIBRhWMl0zbwqt0Eoyyt8VeR4TWUJ2lHiMMXSEWxyeRlRk6g==
X-Received: by 2002:a92:ca0a:0:b0:2cf:4d8e:de17 with SMTP id j10-20020a92ca0a000000b002cf4d8ede17mr7255476ils.146.1652108127903;
        Mon, 09 May 2022 07:55:27 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q20-20020a02a994000000b0032b3a7817c5sm3650735jam.137.2022.05.09.07.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 07:55:27 -0700 (PDT)
Message-ID: <b287fe95-464b-049a-742d-9c9b3d2eeb4f@kernel.dk>
Date:   Mon, 9 May 2022 08:55:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] io_uring: track fixed files with a bitmap
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
 <20220508234909.224108-2-axboe@kernel.dk>
 <f85a7296-54af-800b-c05d-6b526dc87b7d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f85a7296-54af-800b-c05d-6b526dc87b7d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 7:26 AM, Hao Xu wrote:
> ? 2022/5/9 ??7:49, Jens Axboe ??:
>> In preparation for adding a basic allocator for direct descriptors,
>> add helpers that set/clear whether a file slot is used.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c | 37 +++++++++++++++++++++++++++++++++++--
>>   1 file changed, 35 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b6d491c9a25f..6eac6629e7d4 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -257,6 +257,7 @@ struct io_rsrc_put {
>>     struct io_file_table {
>>       struct io_fixed_file *files;
>> +    unsigned long *bitmap;
>>   };
>>     struct io_rsrc_node {
>> @@ -7573,6 +7574,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>>       /* mask in overlapping REQ_F and FFS bits */
>>       req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
>>       io_req_set_rsrc_node(req, ctx, 0);
>> +    WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
>>   out:
>>       io_ring_submit_unlock(ctx, issue_flags);
>>       return file;
>> @@ -8639,13 +8641,35 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
>>   {
>>       table->files = kvcalloc(nr_files, sizeof(table->files[0]),
>>                   GFP_KERNEL_ACCOUNT);
>> -    return !!table->files;
>> +    if (unlikely(!table->files))
>> +        return false;
>> +
>> +    table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
>> +    if (unlikely(!table->bitmap)) {
>> +        kvfree(table->files);
>> +        return false;
>> +    }
>> +
>> +    return true;
>>   }
>>     static void io_free_file_tables(struct io_file_table *table)
>>   {
>>       kvfree(table->files);
>> +    bitmap_free(table->bitmap);
>>       table->files = NULL;
>> +    table->bitmap = NULL;
>> +}
>> +
>> +static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
>> +{
>> +    WARN_ON_ONCE(test_bit(bit, table->bitmap));
>> +    __set_bit(bit, table->bitmap);
>> +}
>> +
>> +static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
>> +{
>> +    __clear_bit(bit, table->bitmap);
>>   }
>>     static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>> @@ -8660,6 +8684,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>               continue;
>>           if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
>>               continue;
>> +        io_file_bitmap_clear(&ctx->file_table, i);
>>           fput(file);
>>       }
>>   #endif
>> @@ -9063,6 +9088,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>           }
>>           file_slot = io_fixed_file_slot(&ctx->file_table, i);
>>           io_fixed_file_set(file_slot, file);
>> +        io_file_bitmap_set(&ctx->file_table, i);
>>       }
>>         io_rsrc_node_switch(ctx, NULL);
>> @@ -9123,6 +9149,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>>           if (ret)
>>               goto err;
>>           file_slot->file_ptr = 0;
>> +        io_file_bitmap_clear(&ctx->file_table, slot_index);
>>           needs_switch = true;
>>       }
>>   @@ -9130,13 +9157,16 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>>       if (!ret) {
>>           *io_get_tag_slot(ctx->file_data, slot_index) = 0;
>>           io_fixed_file_set(file_slot, file);
>> +        io_file_bitmap_set(&ctx->file_table, slot_index);
> [1]
>>       }
>>   err:
>>       if (needs_switch)
>>           io_rsrc_node_switch(ctx, ctx->file_data);
>>       io_ring_submit_unlock(ctx, issue_flags);
>> -    if (ret)
>> +    if (ret) {
>> +        io_file_bitmap_clear(&ctx->file_table, slot_index);
> We don't need to clean it, since we get here only when we didn't
> run [1], which means we haven't set it.

Good point, agree. I'll drop that one.

-- 
Jens Axboe

