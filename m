Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF961F25A
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKGMEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiKGMEU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:04:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92646D5E
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667822602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dgevfi9JfZWNHxu7XwU87txqyjISsLvefLkDV9VoicI=;
        b=BlDTZjUpBwrBQP9mr5w5PENntPJ1RNfKEd13ElPtnLzs8yWMrczsxZv9nvK/HVc7pER/4a
        47sODMCfmVKJLCJisuoSU6tKTAyf6P49IV64PnvNJRV4uUiQS3v7iI9Rl64KUOTkiNSn8/
        t2vIBlNRB47laVCVgN4LOepRK8ngAjA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-8JXvQZx1OaeHmLZJFMvUhA-1; Mon, 07 Nov 2022 07:03:21 -0500
X-MC-Unique: 8JXvQZx1OaeHmLZJFMvUhA-1
Received: by mail-pj1-f71.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so5162675pjm.0
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:03:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dgevfi9JfZWNHxu7XwU87txqyjISsLvefLkDV9VoicI=;
        b=unTjkzK6whV7VbuHzp7JabndBopKFL8+iC4t+VJ4yp25sdutzoHtUZv6G5QH4729Tq
         BNT1dPOfd9l3BgAWaBvtqGS5oKHS+hnMcdndrGBh04Xki0zyAlaLxe1Jm+WTV++xjFTh
         78SYb7MjtRBr2l2p8vkaMWwpy6QZ6J7jBoYtMerjz6a6mQW8iUbm/eaNfbaqVApiugs7
         wxUqT3qCgxWW7wR8IhfKtY54X2vRQP92Wlx9N2RWNrl3hnJ9AEgU9E1XsPFuiBj/+i7p
         /fwVCvrLnaQvc1bN6M8MABjsGp8sh/To+QdKqnUi0JIOt2Vor3tjnGADUWklFFAKN9TD
         hCMQ==
X-Gm-Message-State: ACrzQf3XVoLLpfRm92pMtdLD5IO0256VmOAalH6uEluE6+1QdMHnumWe
        4aPK7JCnVk7K+E5eUbMdIFv35+ns3SMFwfFLJEQwCKQaJBXzR9tq/qh/MrfbHh5OjaxOzIF0WSA
        wW6dPcZFVh/iREeTEB4g=
X-Received: by 2002:a17:902:ec92:b0:186:9fc6:868c with SMTP id x18-20020a170902ec9200b001869fc6868cmr49745489plg.12.1667822600082;
        Mon, 07 Nov 2022 04:03:20 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7FZHFhv5JZjxPbk1tPaIrCTR/ZQHNIK6xnj/4OSQ68xLOV+J8RHhjd6AZy+o5hctDb2kO+fQ==
X-Received: by 2002:a17:902:ec92:b0:186:9fc6:868c with SMTP id x18-20020a170902ec9200b001869fc6868cmr49745463plg.12.1667822599696;
        Mon, 07 Nov 2022 04:03:19 -0800 (PST)
Received: from [10.72.12.88] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b29-20020a631b5d000000b0047022e07035sm4043795pgm.47.2022.11.07.04.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 04:03:19 -0800 (PST)
Subject: Re: [RFC PATCH] fs/lock: increase the filp's reference for
 Posix-style locks
To:     Jeff Layton <jlayton@kernel.org>, viro@zeniv.linux.org.uk,
        chuck.lever@oracle.com
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, idryomov@gmail.com, lhenriques@suse.de,
        gfarnum@redhat.com
References: <20221107095232.36828-1-xiubli@redhat.com>
 <2f1fe2fe57f39ab420c7855584ae7b6bb85a7692.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c5a2cf05-8e30-1fac-3c48-d4b508ea9009@redhat.com>
Date:   Mon, 7 Nov 2022 20:03:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2f1fe2fe57f39ab420c7855584ae7b6bb85a7692.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 07/11/2022 18:33, Jeff Layton wrote:
> On Mon, 2022-11-07 at 17:52 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When closing the file descripters in parallel in multiple threads,
>> who are sharing the same file descripters, the filp_close() will
>> remove all the Posix-style locks. But if two threads both calling
>> the filp_close() it may race and cause use-after-free crash:
>>
>>   PID: 327771   TASK: ffff952aa1db3180  CPU: 8    COMMAND: "db2fmp"
>>    #0 [ffff95202f33b960] machine_kexec at ffffffff890662f4
>>    #1 [ffff95202f33b9c0] __crash_kexec at ffffffff89122b82
>>    #2 [ffff95202f33ba90] crash_kexec at ffffffff89122c70
>>    #3 [ffff95202f33baa8] oops_end at ffffffff89791798
>>    #4 [ffff95202f33bad0] no_context at ffffffff89075d14
>>    #5 [ffff95202f33bb20] __bad_area_nosemaphore at ffffffff89075fe2
>>    #6 [ffff95202f33bb70] bad_area_nosemaphore at ffffffff89076104
>>    #7 [ffff95202f33bb80] __do_page_fault at ffffffff89794750
>>    #8 [ffff95202f33bbf0] do_page_fault at ffffffff89794975
>>    #9 [ffff95202f33bc20] page_fault at ffffffff89790778
>>       [exception RIP: ceph_fl_release_lock+20]
>>       RIP: ffffffffc08247a4  RSP: ffff95202f33bcd0  RFLAGS: 00010286
>>       RAX: ffff952d4ebd8a00  RBX: 0000000000000000  RCX: dead000000000200
>>       RDX: ffff95202f33bd60  RSI: ffff95202f33bd60  RDI: ffff9526b6ac5b00
>>       RBP: ffff95202f33bce0   R8: ffff9526b6ac5b18   R9: ffffffffc083c368
>>       R10: 0000000000001109  R11: 0000000000000000  R12: ffff95202f33bd60
>>       R13: ffff9526b6ac5b00  R14: 0000000000000000  R15: 0000000000000000
>>       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>   #10 [ffff95202f33bce8] locks_release_private at ffffffff892ab3d7
>>   #11 [ffff95202f33bd00] locks_free_lock at ffffffff892ac34d
>>   #12 [ffff95202f33bd18] locks_dispose_list at ffffffff892ac44b
>>   #13 [ffff95202f33bd40] __posix_lock_file at ffffffff892acdfa
>>   #14 [ffff95202f33bda8] posix_lock_file at ffffffff892ad146
>>   #15 [ffff95202f33bdb8] ceph_lock at ffffffffc0824e8a [ceph]
>>   #16 [ffff95202f33bdf8] vfs_lock_file at ffffffff892ad185
>>   #17 [ffff95202f33be08] locks_remove_posix at ffffffff892ad239
>>   #18 [ffff95202f33bee0] locks_remove_posix at ffffffff892ad2a0
>>   #19 [ffff95202f33bef0] filp_close at ffffffff8924baa6
>>   #20 [ffff95202f33bf18] __close_fd at ffffffff8926f89c
>>   #21 [ffff95202f33bf40] sys_close at ffffffff8924d503
>>   #22 [ffff95202f33bf50] system_call_fastpath at ffffffff89799f92
>>       RIP: 00007f806ec446ab  RSP: 00007f80517f0d90  RFLAGS: 00010206
>>       RAX: 0000000000000003  RBX: 00007f8030001a20  RCX: 00007f80300386b0
>>       RDX: 00007f806ef0d880  RSI: 0000000000000001  RDI: 0000000000000006
>>       RBP: 00007f806ef0e3c0   R8: 00007f80517fa700   R9: 0000000000000000
>>       R10: 0000000000000000  R11: 0000000000000206  R12: 0000000000000000
>>       R13: 00007f80300035b0  R14: 00007f80517f1104  R15: 000000000000006c
>>       ORIG_RAX: 0000000000000003  CS: 0033  SS: 002b
>>
>> We need to make sure that the filp in the file_lock shouldn't be
>> release when any file_lock is still referring to it.
>>
>> For the Posix-style locks, whose owner will be the thread ids, we
>> will increase the filp's reference.
>>
>> URL: https://tracker.ceph.com/issues/57986
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   drivers/android/binder.c |  2 +-
>>   fs/file.c                | 15 ++++++++++-----
>>   fs/locks.c               | 18 +++++++++++++++---
>>   include/linux/fs.h       | 14 ++++++++++++++
>>   io_uring/openclose.c     |  3 ++-
>>   5 files changed, 42 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
>> index 880224ec6abb..03692564d940 100644
>> --- a/drivers/android/binder.c
>> +++ b/drivers/android/binder.c
>> @@ -1924,7 +1924,7 @@ static void binder_deferred_fd_close(int fd)
>>   	if (twcb->file) {
>>   		// pin it until binder_do_fd_close(); see comments there
>>   		get_file(twcb->file);
>> -		filp_close(twcb->file, current->files);
>> +		filp_close(twcb->file, file_lock_make_thread_owner(current->files));
>>   		task_work_add(current, &twcb->twork, TWA_RESUME);
>>   	} else {
>>   		kfree(twcb);
>> diff --git a/fs/file.c b/fs/file.c
>> index 5f9c802a5d8d..39ad8e74a8d9 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -417,6 +417,7 @@ static struct fdtable *close_files(struct files_struct * files)
>>   	 * files structure.
>>   	 */
>>   	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>   	unsigned int i, j = 0;
>>   
>>   	for (;;) {
>> @@ -429,7 +430,7 @@ static struct fdtable *close_files(struct files_struct * files)
>>   			if (set & 1) {
>>   				struct file * file = xchg(&fdt->fd[i], NULL);
>>   				if (file) {
>> -					filp_close(file, files);
>> +					filp_close(file, owner);
>>   					cond_resched();
>>   				}
>>   			}
>> @@ -653,6 +654,7 @@ static struct file *pick_file(struct files_struct *files, unsigned fd)
>>   int close_fd(unsigned fd)
>>   {
>>   	struct files_struct *files = current->files;
>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>   	struct file *file;
>>   
>>   	spin_lock(&files->file_lock);
>> @@ -661,7 +663,7 @@ int close_fd(unsigned fd)
>>   	if (!file)
>>   		return -EBADF;
>>   
>> -	return filp_close(file, files);
>> +	return filp_close(file, owner);
>>   }
>>   EXPORT_SYMBOL(close_fd); /* for ksys_close() */
>>   
>> @@ -695,6 +697,7 @@ static inline void __range_cloexec(struct files_struct *cur_fds,
>>   static inline void __range_close(struct files_struct *cur_fds, unsigned int fd,
>>   				 unsigned int max_fd)
>>   {
>> +	fl_owner_t owner = file_lock_make_thread_owner(cur_fds);
>>   	unsigned n;
>>   
>>   	rcu_read_lock();
>> @@ -711,7 +714,7 @@ static inline void __range_close(struct files_struct *cur_fds, unsigned int fd,
>>   
>>   		if (file) {
>>   			/* found a valid file to close */
>> -			filp_close(file, cur_fds);
>> +			filp_close(file, owner);
>>   			cond_resched();
>>   		}
>>   	}
>> @@ -816,6 +819,7 @@ struct file *close_fd_get_file(unsigned int fd)
>>   
>>   void do_close_on_exec(struct files_struct *files)
>>   {
>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>   	unsigned i;
>>   	struct fdtable *fdt;
>>   
>> @@ -841,7 +845,7 @@ void do_close_on_exec(struct files_struct *files)
>>   			rcu_assign_pointer(fdt->fd[fd], NULL);
>>   			__put_unused_fd(files, fd);
>>   			spin_unlock(&files->file_lock);
>> -			filp_close(file, files);
>> +			filp_close(file, owner);
>>   			cond_resched();
>>   			spin_lock(&files->file_lock);
>>   		}
>> @@ -1080,6 +1084,7 @@ static int do_dup2(struct files_struct *files,
>>   	struct file *file, unsigned fd, unsigned flags)
>>   __releases(&files->file_lock)
>>   {
>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>   	struct file *tofree;
>>   	struct fdtable *fdt;
>>   
>> @@ -1111,7 +1116,7 @@ __releases(&files->file_lock)
>>   	spin_unlock(&files->file_lock);
>>   
>>   	if (tofree)
>> -		filp_close(tofree, files);
>> +		filp_close(tofree, owner);
>>   
>>   	return fd;
>>   
>> diff --git a/fs/locks.c b/fs/locks.c
>> index 607f94a0e789..e8b67f87e0ee 100644
>> --- a/fs/locks.c
>> +++ b/fs/locks.c
>> @@ -331,6 +331,8 @@ EXPORT_SYMBOL_GPL(locks_owner_has_blockers);
>>   /* Free a lock which is not in use. */
>>   void locks_free_lock(struct file_lock *fl)
>>   {
>> +	if (fl->fl_file && file_lock_is_thread_owner(fl->fl_owner))
>> +		fput(fl->fl_file);
>>   	locks_release_private(fl);
>>   	kmem_cache_free(filelock_cache, fl);
>>   }
>> @@ -384,7 +386,10 @@ void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
>>   
>>   	locks_copy_conflock(new, fl);
>>   
>> -	new->fl_file = fl->fl_file;
>> +	if (file_lock_is_thread_owner(new->fl_owner))
>> +		new->fl_file = get_file(fl->fl_file);
>> +	else
>> +		new->fl_file = fl->fl_file;
>>   	new->fl_ops = fl->fl_ops;
>>   
>>   	if (fl->fl_ops) {
>> @@ -488,13 +493,14 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
>>   	} else
>>   		fl->fl_end = OFFSET_MAX;
>>   
>> -	fl->fl_owner = current->files;
>> +	fl->fl_owner = file_lock_make_thread_owner(current->files);
>>   	fl->fl_pid = current->tgid;
>> -	fl->fl_file = filp;
>> +	fl->fl_file = get_file(filp);
>>   	fl->fl_flags = FL_POSIX;
>>   	fl->fl_ops = NULL;
>>   	fl->fl_lmops = NULL;
>>   
>> +
>>   	return assign_type(fl, l->l_type);
>>   }
>>   
>> @@ -2243,6 +2249,7 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock *flock)
>>   
>>   		fl->fl_flags |= FL_OFDLCK;
>>   		fl->fl_owner = filp;
>> +		fput(filp);
>>   	}
>>   
>>   	error = vfs_test_lock(filp, fl);
>> @@ -2376,6 +2383,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
>>   		cmd = F_SETLK;
>>   		file_lock->fl_flags |= FL_OFDLCK;
>>   		file_lock->fl_owner = filp;
>> +		fput(filp);
>>   		break;
>>   	case F_OFD_SETLKW:
>>   		error = -EINVAL;
>> @@ -2385,6 +2393,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
>>   		cmd = F_SETLKW;
>>   		file_lock->fl_flags |= FL_OFDLCK;
>>   		file_lock->fl_owner = filp;
>> +		fput(filp);
>>   		fallthrough;
>>   	case F_SETLKW:
>>   		file_lock->fl_flags |= FL_SLEEP;
>> @@ -2450,6 +2459,7 @@ int fcntl_getlk64(struct file *filp, unsigned int cmd, struct flock64 *flock)
>>   		cmd = F_GETLK64;
>>   		fl->fl_flags |= FL_OFDLCK;
>>   		fl->fl_owner = filp;
>> +		fput(filp);
>>   	}
>>   
>>   	error = vfs_test_lock(filp, fl);
>> @@ -2499,6 +2509,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
>>   		cmd = F_SETLK64;
>>   		file_lock->fl_flags |= FL_OFDLCK;
>>   		file_lock->fl_owner = filp;
>> +		fput(filp);
>>   		break;
>>   	case F_OFD_SETLKW:
>>   		error = -EINVAL;
>> @@ -2508,6 +2519,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
>>   		cmd = F_SETLKW64;
>>   		file_lock->fl_flags |= FL_OFDLCK;
>>   		file_lock->fl_owner = filp;
>> +		fput(filp);
>>   		fallthrough;
>>   	case F_SETLKW64:
>>   		file_lock->fl_flags |= FL_SLEEP;
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index e654435f1651..d7d81962a863 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1028,6 +1028,20 @@ static inline struct file *get_file(struct file *f)
>>   /* legacy typedef, should eventually be removed */
>>   typedef void *fl_owner_t;
>>   
>> +/*
>> + * Set the last significant bit to 1 to mark that
>> + * we have get a reference of the fl->fl_file.
>> + */
>> +static inline fl_owner_t file_lock_make_thread_owner(fl_owner_t owner)
>> +{
>> +	return (fl_owner_t)((unsigned long)owner | 1UL);
>> +}
>> +
>> +static inline bool file_lock_is_thread_owner(fl_owner_t owner)
>> +{
>> +	return ((unsigned long)owner & 1UL);
>> +}
>> +
>>   struct file_lock;
>>   
>>   struct file_lock_operations {
>> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
>> index 67178e4bb282..5a12cdf7f8d0 100644
>> --- a/io_uring/openclose.c
>> +++ b/io_uring/openclose.c
>> @@ -212,6 +212,7 @@ int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>>   	struct files_struct *files = current->files;
>> +	fl_owner_t owner = file_lock_make_thread_owner(files);
>>   	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
>>   	struct fdtable *fdt;
>>   	struct file *file;
>> @@ -247,7 +248,7 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>   		goto err;
>>   
>>   	/* No ->flush() or already async, safely close from here */
>> -	ret = filp_close(file, current->files);
>> +	ret = filp_close(file, owner);
>>   err:
>>   	if (ret < 0)
>>   		req_set_fail(req);
> I think this is the wrong approach to fixing this. It also looks like
> you could hit a similar problem with OFD locks and this patch wouldn't
> address that issue.

For the OFD locks they will set the 'file' struct as the owner just as 
the flock does, it should be okay and I don't think it has this issue if 
my understanding is correct here.

> The real bug seems to be that ceph_fl_release_lock dereferences fl_file,
> at a point when it shouldn't rely on that being valid. Most filesystems
> stash some info in fl->fl_u if they need to do bookkeeping after
> releasing a lock. Perhaps ceph should be doing something similar?

This is the 'filp' memory in filp_close(filp, ...):

crash> file.f_path.dentry,f_inode 0xffff952d7ab46200
   f_path.dentry = 0xffff9521b121cb40
   f_inode = 0xffff951f3ea33550,

We can see the 'f_inode' is pointing to the correct inode memory.


While later in 'ceph_fl_release_lock()':

41 static void ceph_fl_release_lock(struct file_lock *fl)
42 {
43     struct ceph_file_info *fi = fl->fl_file->private_data;
44     struct inode *inode = file_inode(fl->fl_file);
45     struct ceph_inode_info *ci = ceph_inode(inode);
46     atomic_dec(&fi->num_locks);
47     if (atomic_dec_and_test(&ci->i_filelock_ref)) {
48         /* clear error when all locks are released */
49         spin_lock(&ci->i_ceph_lock);
50         ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
51         spin_unlock(&ci->i_ceph_lock);
52     }
53 }

It crashed in Line#47 and the 'fl->fl_file' memory is:

crash> file.f_path.dentry,f_inode 0xffff952d4ebd8a00
   f_path.dentry = 0x0
   f_inode = 0x0,

Please NOTE: the 'filp' and 'fl->fl_file' are two different 'file struct'.

Can we fix this by using 'fl->fl_u' here ?

I was also thinking I could just call the 'get_file(file)' in 
ceph_lock() and then in ceph_fl_release_lock() release the reference 
counter. How about this ?

Thanks!

- Xiubo

