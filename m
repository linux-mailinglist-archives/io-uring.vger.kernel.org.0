Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE71D1196F9
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 22:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfLJVaW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 16:30:22 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39621 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbfLJVJ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 16:09:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so16843799oty.6
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 13:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sz83zlf+Qc4HI/UvJA/oK7GYq0TXVgRf5WE2WEm5qGM=;
        b=L5LusMnhQKItUSLtLl2cA3z7UIxH0trl/aUTBRAhX4o+6jop42HD+aLvvjA4ANAb9a
         5mqBQ4/dgH/7wJCBVjfGr1FTxWom9eyIZo76msTOnEx+YnKF2rTud4GORV4QZvX0IBYV
         pM09o71xTExTKlquM6UR3+ZrspkXL+TnhF5gncGZZQScJWNl0M4QPjlmbSWzkEGkUfyC
         Jh/Hq6SMy4i0pTcuSwFqrhECkqaICB9QJ6ghg4+1A2Ci86Te6Xm0p+XfzCBkr6yZh9jQ
         ikXCfHHHO8dFTtS9u9dz1XQ81Kfb7TNe4sVxccfCrycM2f/7PlRsK6C1nAC2hK31iECt
         AJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sz83zlf+Qc4HI/UvJA/oK7GYq0TXVgRf5WE2WEm5qGM=;
        b=knPmLl04g1Bh322UN625rkK4eD5BdhXJTelsmwQuDAHrruXlDPyt5DsjXadzJlfc+Q
         fcF2cM4zbU7iVbMcpbUTDzg+HwMJHAoPMbKbF+Gthe77lhTNs0jpDQT4h2+KT5Dx8xd3
         SvzVai5EupXVeYcv6uHNA3t4ovyOULxolVva6lPR4xIZ78Em9bOFCLSVOOsJDUBYShoN
         flhVlhSHpc9+ZTZj52oqRJb/5ezU2syqG2W22fRfIXqPFVKiGZX5WY/F40MWruCB17sR
         uTMh+FTUkJKULB0fKzTUZu30k6a7+IbFldbdlHq5G0Qf1EL4SwSDFN951rVRMy9tg+v3
         ghjQ==
X-Gm-Message-State: APjAAAUPkB1aVSJoFHq7tSbUO/1S3H5y8P/vZ1sIBLzz37Jko1aF/zPy
        yZBexHAaUQ5Htmkx6EPUs6QkLdf4UZ2305werMD5iNI8
X-Google-Smtp-Source: APXvYqzKakQbLnjvY/lNsqrRfTCQbGieQ3SmignsSu81Fg3h8jJz61DWJoZwtgkbAQqDWNj0shrvpEt+dsxoQUvfCyM=
X-Received: by 2002:a9d:4789:: with SMTP id b9mr28524129otf.110.1576012194253;
 Tue, 10 Dec 2019 13:09:54 -0800 (PST)
MIME-Version: 1.0
References: <0e64d3be-c6b0-dc0d-57f7-da3312bfa743@kernel.dk>
In-Reply-To: <0e64d3be-c6b0-dc0d-57f7-da3312bfa743@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 10 Dec 2019 22:09:28 +0100
Message-ID: <CAG48ez3ezOA2nDazwLXJgz36fzZfU7Po8vSGxfsO3JL2HiTz=g@mail.gmail.com>
Subject: Re: [PATCH] io_uring: avoid ring quiesce for fixed file set
 unregister and update
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 10, 2019 at 5:06 PM Jens Axboe <axboe@kernel.dk> wrote:
> We currently fully quiesce the ring before an unregister or update of
> the fixed fileset. This is very expensive, and we can be a bit smarter
> about this.
>
> Add a percpu refcount for the file tables as a whole. Grab a percpu ref
> when we use a registered file, and put it on completion. This is cheap
> to do. Upon removal of a file from a set, switch the ref count to atomic
> mode. When we hit zero ref on the completion side, then we know we can
> drop the previously registered files. When the old files have been
> dropped, switch the ref back to percpu mode for normal operation.
>
> Since there's a period between doing the update and the kernel being
> done with it, add a IORING_OP_FILES_UPDATE opcode that can perform the
> same action. The application knows the update has completed when it gets
> the CQE for it. Between doing the update and receiving this completion,
> the application must continue to use the unregistered fd if submitting
> IO on this particular file.
>
> This takes the runtime of test/file-register from liburing from 14s to
> about 0.7s.

Uwaaah, the lifetimes and stuff in uring are a maze... this code could
really use some more comments. I haven't really been looking at it for
the last few months, and it's really hard to understand what's going
on now.

[...]
> @@ -456,7 +467,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>         if (!ctx->fallback_req)
>                 goto err;
>
> -       ctx->completions = kmalloc(2 * sizeof(struct completion), GFP_KERNEL);
> +       ctx->completions = kmalloc(3 * sizeof(struct completion), GFP_KERNEL);
>         if (!ctx->completions)
>                 goto err;

Not new in this patch, but wouldn't it be better to just make the
completions members of ctx instead of allocating them separately? And
then it'd also be easier to give them proper names instead of
addressing them as array members, which currently makes it very
unclear what's going on. commit 206aefde4f88 ("io_uring: reduce/pack
size of io_ring_ctx") moved them away because, according to the commit
message, they aren't always necessary and can be allocated
dynamically; but actually, they're still allocated in
io_ring_ctx_alloc() and freed in io_ring_ctx_free(), together with the
context.

[...]
> @@ -881,8 +893,12 @@ static void __io_free_req(struct io_kiocb *req)
>
>         if (req->io)
>                 kfree(req->io);
> -       if (req->file && !(req->flags & REQ_F_FIXED_FILE))
> -               fput(req->file);
> +       if (req->file) {
> +               if (req->flags & REQ_F_FIXED_FILE)
> +                       percpu_ref_put(&ctx->file_data->refs);
> +               else
> +                       fput(req->file);
> +       }
>         if (req->flags & REQ_F_INFLIGHT) {
>                 unsigned long flags;
[...]
> @@ -3090,8 +3140,8 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
>  {
>         struct fixed_file_table *table;
>
> -       table = &ctx->file_table[index >> IORING_FILE_TABLE_SHIFT];
> -       return table->files[index & IORING_FILE_TABLE_MASK];
> +       table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
> +       return READ_ONCE(table->files[index & IORING_FILE_TABLE_MASK]);

What is this READ_ONCE() for? Aren't the table entries fully protected
by the uring_lock?

>  }
>
>  static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
> @@ -3110,7 +3160,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
>                 return 0;
>
>         if (flags & IOSQE_FIXED_FILE) {
> -               if (unlikely(!ctx->file_table ||
> +               if (unlikely(!ctx->file_data ||
>                     (unsigned) fd >= ctx->nr_user_files))
>                         return -EBADF;
>                 fd = array_index_nospec(fd, ctx->nr_user_files);
> @@ -3118,6 +3168,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
>                 if (!req->file)
>                         return -EBADF;
>                 req->flags |= REQ_F_FIXED_FILE;
> +               percpu_ref_get(&ctx->file_data->refs);
>         } else {
>                 if (req->needs_fixed_file)
>                         return -EBADF;
> @@ -3796,15 +3847,18 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  {
>         unsigned nr_tables, i;
>
> -       if (!ctx->file_table)
> +       if (!ctx->file_data)
>                 return -ENXIO;
>
> +       percpu_ref_kill(&ctx->file_data->refs);
> +       wait_for_completion(&ctx->completions[2]);
>         __io_sqe_files_unregister(ctx);
>         nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>         for (i = 0; i < nr_tables; i++)
> -               kfree(ctx->file_table[i].files);
> -       kfree(ctx->file_table);
> -       ctx->file_table = NULL;
> +               kfree(ctx->file_data->table[i].files);
> +       kfree(ctx->file_data->table);
> +       kfree(ctx->file_data);
> +       ctx->file_data = NULL;
>         ctx->nr_user_files = 0;
>         return 0;
>  }
[...]
> +static void io_ring_file_ref_switch(struct io_wq_work **workptr)
> +{
> +       struct fixed_file_data *data;
> +       struct llist_node *node;
> +       struct file *file, *tmp;
> +
> +       data = container_of(*workptr, struct fixed_file_data, ref_work);
> +
> +       clear_bit_unlock(0, (unsigned long *) &data->ref_work.files);

Starting at this point, multiple executions of this function can race
with each other, right? Which means that the complete() call further
down can happen multiple times? Is that okay?

> +       smp_mb__after_atomic();
> +
> +       while ((node = llist_del_all(&data->put_llist)) != NULL) {
> +               llist_for_each_entry_safe(file, tmp, node, f_u.fu_llist)
> +                       io_ring_file_put(data->ctx, file);
> +       }

Why "while"? You expect someone to place new stuff on the ->put_llist
while in the llist_for_each_entry_safe() loop and don't want to wait
for the next execution of io_ring_file_ref_switch()? Or am I missing
something here?

> +       percpu_ref_switch_to_percpu(&data->refs);
> +       if (percpu_ref_is_dying(&data->refs))
> +               complete(&data->ctx->completions[2]);
> +}
> +
> +static void io_file_data_ref_zero(struct percpu_ref *ref)
> +{
> +       struct fixed_file_data *data;
> +
> +       data = container_of(ref, struct fixed_file_data, refs);
> +       if (test_and_set_bit_lock(0, (unsigned long *) &data->ref_work.files))
> +               return;

You're reusing the low bit of a pointer field in io_wq_work as an
atomic flag? If I understand correctly, io_ring_file_ref_switch work
items just use that field to store this flag and don't use it as a
pointer, right? In that case, shouldn't the field be a union instead
of using such a cast? (You could make it an unnamed union if you're
worried about having to rename stuff everywhere.)

> +       if (!llist_empty(&data->put_llist)) {
> +               percpu_ref_get(&data->refs);
> +               io_wq_enqueue(data->ctx->io_wq, &data->ref_work);
> +       } else {
> +               clear_bit_unlock(0, (unsigned long *) &data->ref_work.files);
> +               if (percpu_ref_is_dying(&data->refs))
> +                       complete(&data->ctx->completions[2]);
> +       }
> +}
> +
>  static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>                                  unsigned nr_args)
>  {
>         __s32 __user *fds = (__s32 __user *) arg;
>         unsigned nr_tables;
> +       struct file *file;
>         int fd, ret = 0;
>         unsigned i;
>
> -       if (ctx->file_table)
> +       if (ctx->file_data)
>                 return -EBUSY;
>         if (!nr_args)
>                 return -EINVAL;
>         if (nr_args > IORING_MAX_FIXED_FILES)
>                 return -EMFILE;
>
> +       ctx->file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
> +       if (!ctx->file_data)
> +               return -ENOMEM;
> +       ctx->file_data->ctx = ctx;
> +
>         nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
> -       ctx->file_table = kcalloc(nr_tables, sizeof(struct fixed_file_table),
> +       ctx->file_data->table = kcalloc(nr_tables,
> +                                       sizeof(struct fixed_file_table),
>                                         GFP_KERNEL);
> -       if (!ctx->file_table)
> +       if (!ctx->file_data->table) {
> +               kfree(ctx->file_data);
> +               ctx->file_data = NULL;
>                 return -ENOMEM;
> +       }
> +
> +       if (percpu_ref_init(&ctx->file_data->refs, io_file_data_ref_zero,
> +                               PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> +               kfree(ctx->file_data->table);
> +               kfree(ctx->file_data);
> +               ctx->file_data = NULL;
> +       }
> +       ctx->file_data->put_llist.first = NULL;
> +       INIT_IO_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
> +       ctx->file_data->ref_work.flags = IO_WQ_WORK_INTERNAL;

Why are you punting the ref switch onto a workqueue? Is this in case
the refcount is still in the middle of switching from percpu mode to
atomic?

>         if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
> -               kfree(ctx->file_table);
> -               ctx->file_table = NULL;
> +               percpu_ref_exit(&ctx->file_data->refs);

You call percpu_ref_exit() in this failure path, but nowhere else?
That seems to me like it implies at least a memory leak, if not worse.

> +               kfree(ctx->file_data->table);
> +               kfree(ctx->file_data);
> +               ctx->file_data = NULL;
>                 return -ENOMEM;
>         }
>
> @@ -4015,13 +4191,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>                         continue;
>                 }
>
> -               table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
> +               table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>                 index = i & IORING_FILE_TABLE_MASK;
> -               table->files[index] = fget(fd);
> +               file = fget(fd);
>
>                 ret = -EBADF;
> -               if (!table->files[index])
> +               if (!file)
>                         break;

Not new in this commit, but it seems kinda awkward to have to
open-code the table lookup here... this might be nicer if instead of
"struct file *io_file_from_index(...)", you had "struct file
**io_file_ref_from_index(...)".

>                 /*
>                  * Don't allow io_uring instances to be registered. If UNIX
>                  * isn't enabled, then this causes a reference cycle and this
> @@ -4029,26 +4206,26 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>                  * handle it just fine, but there's still no point in allowing
>                  * a ring fd as it doesn't support regular read/write anyway.
>                  */
> -               if (table->files[index]->f_op == &io_uring_fops) {
> -                       fput(table->files[index]);
> +               if (file->f_op == &io_uring_fops) {
> +                       fput(file);
>                         break;
>                 }
>                 ret = 0;
> +               WRITE_ONCE(table->files[index], file);

Why WRITE_ONCE()? There are no readers who can see the file at this
point, right?

>         }
>
>         if (ret) {
>                 for (i = 0; i < ctx->nr_user_files; i++) {
> -                       struct file *file;
> -
>                         file = io_file_from_index(ctx, i);
>                         if (file)
>                                 fput(file);
>                 }
>                 for (i = 0; i < nr_tables; i++)
> -                       kfree(ctx->file_table[i].files);
> +                       kfree(ctx->file_data->table[i].files);
>
> -               kfree(ctx->file_table);
> -               ctx->file_table = NULL;
> +               kfree(ctx->file_data->table);
> +               kfree(ctx->file_data);
> +               ctx->file_data = NULL;
>                 ctx->nr_user_files = 0;
>                 return ret;
>         }
[...]
> @@ -4169,12 +4283,16 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
>  static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>                                unsigned nr_args)
>  {
> +       struct fixed_file_data *data = ctx->file_data;
> +       unsigned long __percpu *percpu_count;
>         struct io_uring_files_update up;
> +       bool did_unregister = false;
> +       struct file *file;
>         __s32 __user *fds;
>         int fd, i, err;
>         __u32 done;
>
> -       if (!ctx->file_table)
> +       if (!data)
>                 return -ENXIO;
>         if (!nr_args)
>                 return -EINVAL;
> @@ -4197,15 +4315,15 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>                         break;
>                 }
>                 i = array_index_nospec(up.offset, ctx->nr_user_files);
> -               table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
> +               table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>                 index = i & IORING_FILE_TABLE_MASK;
>                 if (table->files[index]) {
> -                       io_sqe_file_unregister(ctx, i);
> -                       table->files[index] = NULL;
> +                       file = io_file_from_index(ctx, index);
> +                       llist_add(&file->f_u.fu_llist, &data->put_llist);

How can it be safe to implement this with a linked list through a
member of struct file? What happens if someone, for example, uses the
same file in two different uring instances and then calls this update
helper on both of them in parallel? file->f_u.fu_llist will be put on
one list, and then, without removing it from the first list, be
connected to the second list, right? At which point the two lists will
be weirdly spliced together.

> +                       WRITE_ONCE(table->files[index], NULL);
> +                       did_unregister = true;
>                 }
>                 if (fd != -1) {
> -                       struct file *file;
> -
>                         file = fget(fd);
>                         if (!file) {
>                                 err = -EBADF;
> @@ -4224,7 +4342,7 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>                                 err = -EBADF;
>                                 break;
>                         }
> -                       table->files[index] = file;
> +                       WRITE_ONCE(table->files[index], file);

(Again, I don't get the WRITE_ONCE() part.)

>                         err = io_sqe_file_register(ctx, file, i);
>                         if (err)
>                                 break;
> @@ -4234,6 +4352,11 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>                 up.offset++;
>         }
>
> +       if (did_unregister && __ref_is_percpu(&data->refs, &percpu_count)) {
> +               percpu_ref_put(&data->refs);
> +               percpu_ref_switch_to_atomic(&data->refs, NULL);
> +       }

There's a comment on __ref_is_percpu() saying "Internal helper.  Don't
use outside percpu-refcount proper.", and it is some lockless helper
thing that normally only has a meaning when used inside an RCU-sched
read-side critical section. If you want to use that helper outside the
internals of percpu-refcount, I think you'll have to at least change
the documentation of that helper and document under which conditions
it means what.

But I also don't really understand the intent here. It looks like the
idea is that if we've just removed a file from the uring instance, we
want to detect when the number of pending I/O items that use files is
at zero so that we can throw away our reference to the file? And we
hope that we're somehow protected against concurrent mode switches
(which would mean that we must somehow be protected against concurrent
io_ring_file_ref_switch())?

I wonder whether an alternative scheme might be that instead of having
the percpu refcounting logic for the entire file table and keeping
files open until no file I/O is being executed for a moment, you could
iterate through all pending work items (including ones that are
currently being executed) under appropriate locks, and if they use
fixed files that are to-be-removed, flip the type to non-fixed and
increment the file's refcount?
