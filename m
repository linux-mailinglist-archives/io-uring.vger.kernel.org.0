Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221406580E0
	for <lists+io-uring@lfdr.de>; Wed, 28 Dec 2022 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiL1QWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Dec 2022 11:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiL1QWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Dec 2022 11:22:19 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0801A209
        for <io-uring@vger.kernel.org>; Wed, 28 Dec 2022 08:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=jrQMohynqNyC2OVpx+vT+63qR+9DoLdXwl7h7nq24ZU=; b=omJvyFBHBwLrCVqe4fTIZda3yc
        OX0KfrTdbCaE6ivj15EkOxU6anaRdrnE3UER75rLxAVqeh6lwKroVqXX2SImxq1nkw1c0+TGrAi2Z
        rr/uhrfFbZ4XfIAkmmjPqxLt4pryi3GjDMQwhy6ryYXmP5qielL+Mus5pHU5EdkKCMzEnusHupxyi
        TJDmF7jE93g8rdMhiznuYEgvqYztTTTqojSPIkrX8g36QLlaOS2BpqxInkia1I24Fxjbw2ph4rGor
        juOQDmE5h5tTZSlnrbi7uqSFnAy8d7R2aJYzhBOLZAlb23sTvEAPhoiA+Mpj07AMQ14Dtx1250ceN
        cnnd+/dVjGb2YIHG440OeYxWlT0i4Uo1x1CXyMPvCpbYvKrvv4fRDD2tMW67vgb33ey2pA2oAdVs9
        yPS5IuQGL4ovhsRFnq0kww6DhN5ZueOEMsVTN5sHmDNr6QON85ESoBGrz2iyoBKk59gPGC4z8Eab9
        h7MF2FAWjFQyOYD9aU4hwF/1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pAZ9k-005m61-Qe; Wed, 28 Dec 2022 16:19:52 +0000
Message-ID: <79b3e423-16aa-48f1-ee27-a198c2db2ba8@samba.org>
Date:   Wed, 28 Dec 2022 17:19:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Samba Technical <samba-technical@lists.samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <2a9e4484-4025-2806-89c3-51c590cfd176@samba.org>
 <60ce8938-77ed-0b43-0852-7895140c3553@samba.org>
In-Reply-To: <60ce8938-77ed-0b43-0852-7895140c3553@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

any change to get some feedback on these?
https://lore.kernel.org/io-uring/60ce8938-77ed-0b43-0852-7895140c3553@samba.org/
and
https://lore.kernel.org/io-uring/c9a5b180-322c-1eb6-2392-df9370aeb45c@samba.org/

Thanks in advance!
metze

Am 27.10.22 um 21:25 schrieb Stefan Metzmacher:
> Hi Jens,
> 
>>>> I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
>>>> flag that can be passed to POLL_ADD. With that we'll register
>>>> the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
>>>> Then we only get a real reference to the file during the call to
>>>> vfs_poll() otherwise we drop the fget/fput reference and rely on
>>>> an io_uring_poll_release_file() (similar to eventpoll_release_file())
>>>> to cancel our registered poll request.
>>>
>>> Yes, this is a bit tricky as we hold the file ref across the operation. I'd
>>> be interested in seeing your approach to this, and also how it would
>>> interact with registered files...
>>
>> Here's my current patch:
>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=b9cccfac515739fc279c6eec87ce655a96f94685
>> It compiles, but I haven't tested it yet. And I'm not sure if the locking is done correctly...
> 
> It doesn't deadlock nor blow up immediately :-)
> And it does fix the problem I had.
> 
> So what do you think about that patch?
> Am I doing stupid things there?
> 
> These points might be changed:
> - returning -EBADF instead of -ECANCELED
>    might be better and allow the caller to avoid
>    retrying.
> - I guess we could use a single linked list, but
>    I'm mostly used to how struct list_head works.
>    And I want something that works first.
> - We may find a better name than IORING_POLL_CANCEL_ON_CLOSE
> - struct io_poll is completely full, as well as io_kiocb->flags
>    (maybe we should move flags to 64 bit?),
>    so we need to use some other generic struct io_kiocb space,
>    which might also be good in order make it possible to keep io_poll_add()
>    and io_arm_poll_handler() in common.
>    But we may have the new field a bit differently. Note that
>    struct io_kiocb (without this patch) still has 32 free bytes before
>    4 64 byte cachelines are filled. With my patch 24 bytes are left...
> - In struct file it might be possible to share a reference list with
>    with the epoll code, where each element can indicate it epoll
>    or io_uring is used.
> 
> I'm pasting it below in order to make it easier to get comments...
> 
> metze
> 
>   fs/file_table.c                |   3 ++
>   include/linux/fs.h             |   1 +
>   include/linux/io_uring.h       |  12 +++++
>   include/linux/io_uring_types.h |   4 ++
>   include/uapi/linux/io_uring.h  |   1 +
>   io_uring/opdef.c               |   1 +
>   io_uring/poll.c                | 100 ++++++++++++++++++++++++++++++++++++++++-
>   io_uring/poll.h                |   1 +
>   8 files changed, 122 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index dd88701e54a9..cad408e9c0f5 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -16,6 +16,7 @@
>   #include <linux/security.h>
>   #include <linux/cred.h>
>   #include <linux/eventpoll.h>
> +#include <linux/io_uring.h>
>   #include <linux/rcupdate.h>
>   #include <linux/mount.h>
>   #include <linux/capability.h>
> @@ -147,6 +148,7 @@ static struct file *__alloc_file(int flags, const struct cred *cred)
>       }
> 
>       atomic_long_set(&f->f_count, 1);
> +    INIT_LIST_HEAD(&f->f_uring_poll);
>       rwlock_init(&f->f_owner.lock);
>       spin_lock_init(&f->f_lock);
>       mutex_init(&f->f_pos_lock);
> @@ -309,6 +311,7 @@ static void __fput(struct file *file)
>        * in the file cleanup chain.
>        */
>       eventpoll_release(file);
> +    io_uring_poll_release(file);
>       locks_remove_file(file);
> 
>       ima_file_free(file);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e654435f1651..7f99efa7a1dc 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -972,6 +972,7 @@ struct file {
>       /* Used by fs/eventpoll.c to link all the hooks to this file */
>       struct hlist_head    *f_ep;
>   #endif /* #ifdef CONFIG_EPOLL */
> +    struct list_head    f_uring_poll;
>       struct address_space    *f_mapping;
>       errseq_t        f_wb_err;
>       errseq_t        f_sb_err; /* for syncfs */
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 43bc8a2edccf..c931ea92c29a 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -61,6 +61,15 @@ static inline void io_uring_free(struct task_struct *tsk)
>       if (tsk->io_uring)
>           __io_uring_free(tsk);
>   }
> +
> +void io_uring_poll_release_file(struct file *file);
> +static inline void io_uring_poll_release(struct file *file)
> +{
> +    if (likely(list_empty_careful(&file->f_uring_poll)))
> +        return;
> +
> +    io_uring_poll_release_file(file);
> +}
>   #else
>   static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>                     struct iov_iter *iter, void *ioucmd)
> @@ -92,6 +101,9 @@ static inline const char *io_uring_get_opcode(u8 opcode)
>   {
>       return "";
>   }
> +static inline void io_uring_poll_release(struct file *file)
> +{
> +}
>   #endif
> 
>   #endif
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f5b687a787a3..2373e01c57e7 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -547,8 +547,12 @@ struct io_kiocb {
>       union {
>           /* used by request caches, completion batching and iopoll */
>           struct io_wq_work_node    comp_list;
> +        struct {
>           /* cache ->apoll->events */
>           __poll_t apoll_events;
> +        u8 poll_cancel_on_close:1;
> +        struct list_head        f_uring_poll_entry;
> +        };
>       };
>       atomic_t            refs;
>       atomic_t            poll_refs;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index a2ce8ba7abb5..fe311667cb8c 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -276,6 +276,7 @@ enum io_uring_op {
>   #define IORING_POLL_UPDATE_EVENTS    (1U << 1)
>   #define IORING_POLL_UPDATE_USER_DATA    (1U << 2)
>   #define IORING_POLL_ADD_LEVEL        (1U << 3)
> +#define IORING_POLL_CANCEL_ON_CLOSE    (1U << 4)
> 
>   /*
>    * ASYNC_CANCEL flags.
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 34b08c87ffa5..540ee55961a3 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -131,6 +131,7 @@ const struct io_op_def io_op_defs[] = {
>           .name            = "POLL_ADD",
>           .prep            = io_poll_add_prep,
>           .issue            = io_poll_add,
> +        .cleanup        = io_poll_cleanup,
>       },
>       [IORING_OP_POLL_REMOVE] = {
>           .audit_skip        = 1,
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0d9f49c575e0..d4ccf2f2e815 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -163,6 +163,19 @@ static inline void io_poll_remove_entry(struct io_poll *poll)
> 
>   static void io_poll_remove_entries(struct io_kiocb *req)
>   {
> +    if (!list_empty_careful(&req->f_uring_poll_entry)) {
> +        spin_lock(&req->file->f_lock);
> +        list_del_init_careful(&req->f_uring_poll_entry);
> +        /*
> +         * upgrade to a full reference again,
> +         * it will be released in the common
> +         * cleanup code via io_put_file().
> +         */
> +        if (!(req->flags & REQ_F_FIXED_FILE))
> +            WARN_ON_ONCE(!get_file_rcu(req->file));
> +        spin_unlock(&req->file->f_lock);
> +    }
> +
>       /*
>        * Nothing to do if neither of those flags are set. Avoid dipping
>        * into the poll/apoll/double cachelines if we can.
> @@ -199,6 +212,54 @@ enum {
>       IOU_POLL_REMOVE_POLL_USE_RES = 2,
>   };
> 
> +static inline struct file *io_poll_get_additional_file_ref(struct io_kiocb *req,
> +                               unsigned issue_flags)
> +{
> +    if (!(req->poll_cancel_on_close))
> +        return NULL;
> +
> +    if (unlikely(!req->file))
> +        return NULL;
> +
> +    req->flags |= REQ_F_NEED_CLEANUP;
> +
> +    if (list_empty_careful(&req->f_uring_poll_entry)) {
> +        /*
> +         * This first time we need to add ourself to the
> +         * file->f_uring_poll.
> +         */
> +        spin_lock(&req->file->f_lock);
> +        list_add_tail(&req->f_uring_poll_entry, &req->file->f_uring_poll);
> +        spin_unlock(&req->file->f_lock);
> +        if (!(req->flags & REQ_F_FIXED_FILE)) {
> +            /*
> +             * If it's not a fixed file,
> +             * we can allow the caller to drop the existing
> +             * reference.
> +             */
> +            return req->file;
> +        }
> +        /*
> +         * For fixed files we grab an additional reference
> +         */
> +    }
> +
> +    io_ring_submit_lock(req->ctx, issue_flags);
> +    if (unlikely(!req->file)) {
> +        io_ring_submit_unlock(req->ctx, issue_flags);
> +        return NULL;
> +    }
> +    rcu_read_lock();
> +    if (unlikely(!get_file_rcu(req->file))) {
> +        req->file = NULL;
> +        req->cqe.fd = -1;
> +        io_poll_mark_cancelled(req);
> +    }
> +    rcu_read_unlock();
> +    io_ring_submit_unlock(req->ctx, issue_flags);
> +    return req->file;
> +}
> +
>   /*
>    * All poll tw should go through this. Checks for poll events, manages
>    * references, does rewait, etc.
> @@ -230,7 +291,12 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
>           /* the mask was stashed in __io_poll_execute */
>           if (!req->cqe.res) {
>               struct poll_table_struct pt = { ._key = req->apoll_events };
> +            unsigned issue_flags = (!*locked) ? IO_URING_F_UNLOCKED : 0;
> +            struct file *file_to_put = io_poll_get_additional_file_ref(req, issue_flags);
> +            if (unlikely(!req->file))
> +                return -ECANCELED;
>               req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
> +            io_put_file(file_to_put);
>           }
> 
>           if ((unlikely(!req->cqe.res)))
> @@ -499,6 +565,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>                    unsigned issue_flags)
>   {
>       struct io_ring_ctx *ctx = req->ctx;
> +    struct file *file_to_put;
>       int v;
> 
>       INIT_HLIST_NODE(&req->hash_node);
> @@ -506,6 +573,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>       io_init_poll_iocb(poll, mask, io_poll_wake);
>       poll->file = req->file;
>       req->apoll_events = poll->events;
> +    INIT_LIST_HEAD(&req->f_uring_poll_entry);
> 
>       ipt->pt._key = mask;
>       ipt->req = req;
> @@ -529,7 +597,11 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>       if (issue_flags & IO_URING_F_UNLOCKED)
>           req->flags &= ~REQ_F_HASH_LOCKED;
> 
> +    file_to_put = io_poll_get_additional_file_ref(req, issue_flags);
> +    if (unlikely(!req->file))
> +        return -ECANCELED;
>       mask = vfs_poll(req->file, &ipt->pt) & poll->events;
> +    io_put_file(file_to_put);
> 
>       if (unlikely(ipt->error || !ipt->nr_entries)) {
>           io_poll_remove_entries(req);
> @@ -857,11 +929,17 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>       if (sqe->buf_index || sqe->off || sqe->addr)
>           return -EINVAL;
>       flags = READ_ONCE(sqe->len);
> -    if (flags & ~IORING_POLL_ADD_MULTI)
> +    if (flags & ~(IORING_POLL_ADD_MULTI|IORING_POLL_CANCEL_ON_CLOSE))
>           return -EINVAL;
>       if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
>           return -EINVAL;
> 
> +    if (flags & IORING_POLL_CANCEL_ON_CLOSE) {
> +        req->poll_cancel_on_close = 1;
> +    } else {
> +        req->poll_cancel_on_close = 0;
> +    }
> +
>       poll->events = io_poll_parse_events(sqe, flags);
>       return 0;
>   }
> @@ -963,3 +1041,23 @@ void io_apoll_cache_free(struct io_cache_entry *entry)
>   {
>       kfree(container_of(entry, struct async_poll, cache));
>   }
> +
> +void io_uring_poll_release_file(struct file *file)
> +{
> +    struct io_kiocb *req, *next;
> +
> +    list_for_each_entry_safe(req, next, &file->f_uring_poll, f_uring_poll_entry) {
> +        io_ring_submit_lock(req->ctx, IO_URING_F_UNLOCKED);
> +        io_poll_mark_cancelled(req);
> +        list_del_init_careful(&req->f_uring_poll_entry);
> +        io_poll_remove_entries(req);
> +        req->file = NULL;
> +        io_poll_execute(req, 0);
> +        io_ring_submit_unlock(req->ctx, IO_URING_F_UNLOCKED);
> +    }
> +}
> +
> +void io_poll_cleanup(struct io_kiocb *req)
> +{
> +    io_poll_remove_entries(req);
> +}
> diff --git a/io_uring/poll.h b/io_uring/poll.h
> index ef25c26fdaf8..43e6b877f1bc 100644
> --- a/io_uring/poll.h
> +++ b/io_uring/poll.h
> @@ -27,6 +27,7 @@ struct async_poll {
> 
>   int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
> +void io_poll_cleanup(struct io_kiocb *req);
> 
>   int io_poll_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags);
> 

