Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5460B11AD47
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2019 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfLKOW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Dec 2019 09:22:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42020 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKOW4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Dec 2019 09:22:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id x13so1479257plr.9
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2019 06:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KTQYkqBxQKXHvPn/qdyfgH4w0Qe4pRJpKs7oBBP7jjY=;
        b=l2nRiAW5SWyJDQrSbsSZAUG0hcHRCOavrHP4gipkWWYFHQHBjW+Q9GqURoUvlV+OXX
         e00R1NVAuiPV/DbyJxwV+9q7Jf1qvWFW71hItTTXXr3AmLEOECs07LVxVkc0bkgNjjUW
         psrREcc9z451ipDHL4uMcYXSdpCqXSEfVrVlrMtsm5NLlx+QRfLxbg4TieoTvXlfGCaz
         wr/noD7MvP0Z3i3gx0ttfFHZtTNhBeaobD4/Yc3pbvMkJvFe613vw3zlHDi95B29gkG6
         ZK65/wwAKfC5YJuZ73w1SBiZZC5+bDrsEd5/84ALMWUAZn08b7HQiG66vDuk9/wgp5gz
         XFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KTQYkqBxQKXHvPn/qdyfgH4w0Qe4pRJpKs7oBBP7jjY=;
        b=jq7p7xkpMHCXwjL7lcI2qHaHY33E2bsrjjNnj4LPnosxESDFTmil6AIORREXovcDLm
         3PuHceUA0tHWV5AYx0SYsFrkUMApu2vZg6uNSOSyjvS7oGV4GeIoIWWybi57enCmGhV4
         b+TooPsr1A9PqliYsMBWqnKxCrOTlJ7JbtSOYgHyh4Av3N9iACKSlz/6JpGWYIb9gRsA
         KMDDU91taFk1TOKJoDzd+CdPMhLlQkOasZjBif/prSp8CHYFyHpGn3wCVig8rgFyKCat
         bUL8tPeg1AewnD2rWEcWLaZXl6re8/nfs1s7X/So4b2QCXPBU6nKDu2A5poMAJ8ptg0R
         6A1w==
X-Gm-Message-State: APjAAAVPOJNJlNfrPeK89Hzx5KIyL/g5KjPJTqmILPlhoJ6iSKCa0YzU
        DRTClnWTAKi2RzMNq3vniS8TvXsadec=
X-Google-Smtp-Source: APXvYqy5Z/KhvrgrtVly8kAnPzHJ7Pu3bBIvC1Bo8iZ5xMlw/n6b4C82tO48deJJc3HFeTIUCX8emQ==
X-Received: by 2002:a17:90a:ad48:: with SMTP id w8mr3833357pjv.19.1576074174444;
        Wed, 11 Dec 2019 06:22:54 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1014? ([2620:10d:c090:180::50da])
        by smtp.gmail.com with ESMTPSA id 129sm3434739pfw.71.2019.12.11.06.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 06:22:53 -0800 (PST)
Subject: Re: [PATCH] io_uring: avoid ring quiesce for fixed file set
 unregister and update
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0e64d3be-c6b0-dc0d-57f7-da3312bfa743@kernel.dk>
 <CAG48ez3ezOA2nDazwLXJgz36fzZfU7Po8vSGxfsO3JL2HiTz=g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c86cfa51-af78-8686-7b95-2918d54a22d2@kernel.dk>
Date:   Wed, 11 Dec 2019 07:22:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAG48ez3ezOA2nDazwLXJgz36fzZfU7Po8vSGxfsO3JL2HiTz=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 2:09 PM, Jann Horn wrote:
>> @@ -456,7 +467,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>         if (!ctx->fallback_req)
>>                 goto err;
>>
>> -       ctx->completions = kmalloc(2 * sizeof(struct completion), GFP_KERNEL);
>> +       ctx->completions = kmalloc(3 * sizeof(struct completion), GFP_KERNEL);
>>         if (!ctx->completions)
>>                 goto err;
> 
> Not new in this patch, but wouldn't it be better to just make the
> completions members of ctx instead of allocating them separately? And
> then it'd also be easier to give them proper names instead of
> addressing them as array members, which currently makes it very
> unclear what's going on. commit 206aefde4f88 ("io_uring: reduce/pack
> size of io_ring_ctx") moved them away because, according to the commit
> message, they aren't always necessary and can be allocated
> dynamically; but actually, they're still allocated in
> io_ring_ctx_alloc() and freed in io_ring_ctx_free(), together with the
> context.

We could skip allocating the sqthread one if we don't have an sqthread,
that should probably be done. But it was more done to make the layout of
io_ring_ctx nicer, the completions are rather large. Maybe we should
just toss them at the end instead to move them out of the way. I agree
it's not the clearest/cleanest right now.

>> @@ -881,8 +893,12 @@ static void __io_free_req(struct io_kiocb *req)
>>
>>         if (req->io)
>>                 kfree(req->io);
>> -       if (req->file && !(req->flags & REQ_F_FIXED_FILE))
>> -               fput(req->file);
>> +       if (req->file) {
>> +               if (req->flags & REQ_F_FIXED_FILE)
>> +                       percpu_ref_put(&ctx->file_data->refs);
>> +               else
>> +                       fput(req->file);
>> +       }
>>         if (req->flags & REQ_F_INFLIGHT) {
>>                 unsigned long flags;
> [...]
>> @@ -3090,8 +3140,8 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
>>  {
>>         struct fixed_file_table *table;
>>
>> -       table = &ctx->file_table[index >> IORING_FILE_TABLE_SHIFT];
>> -       return table->files[index & IORING_FILE_TABLE_MASK];
>> +       table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
>> +       return READ_ONCE(table->files[index & IORING_FILE_TABLE_MASK]);
> 
> What is this READ_ONCE() for? Aren't the table entries fully protected
> by the uring_lock?

Leftover from a previous iteration on this, I agree we don't need it (or
the READ_ONCE()).

I really should have posted this patch as an RFC, it's not ready to get
queued up for real at this point.

>>  static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
>> @@ -3110,7 +3160,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
>>                 return 0;
>>
>>         if (flags & IOSQE_FIXED_FILE) {
>> -               if (unlikely(!ctx->file_table ||
>> +               if (unlikely(!ctx->file_data ||
>>                     (unsigned) fd >= ctx->nr_user_files))
>>                         return -EBADF;
>>                 fd = array_index_nospec(fd, ctx->nr_user_files);
>> @@ -3118,6 +3168,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
>>                 if (!req->file)
>>                         return -EBADF;
>>                 req->flags |= REQ_F_FIXED_FILE;
>> +               percpu_ref_get(&ctx->file_data->refs);
>>         } else {
>>                 if (req->needs_fixed_file)
>>                         return -EBADF;
>> @@ -3796,15 +3847,18 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>  {
>>         unsigned nr_tables, i;
>>
>> -       if (!ctx->file_table)
>> +       if (!ctx->file_data)
>>                 return -ENXIO;
>>
>> +       percpu_ref_kill(&ctx->file_data->refs);
>> +       wait_for_completion(&ctx->completions[2]);
>>         __io_sqe_files_unregister(ctx);
>>         nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
>>         for (i = 0; i < nr_tables; i++)
>> -               kfree(ctx->file_table[i].files);
>> -       kfree(ctx->file_table);
>> -       ctx->file_table = NULL;
>> +               kfree(ctx->file_data->table[i].files);
>> +       kfree(ctx->file_data->table);
>> +       kfree(ctx->file_data);
>> +       ctx->file_data = NULL;
>>         ctx->nr_user_files = 0;
>>         return 0;
>>  }
> [...]
>> +static void io_ring_file_ref_switch(struct io_wq_work **workptr)
>> +{
>> +       struct fixed_file_data *data;
>> +       struct llist_node *node;
>> +       struct file *file, *tmp;
>> +
>> +       data = container_of(*workptr, struct fixed_file_data, ref_work);
>> +
>> +       clear_bit_unlock(0, (unsigned long *) &data->ref_work.files);
> 
> Starting at this point, multiple executions of this function can race
> with each other, right? Which means that the complete() call further
> down can happen multiple times? Is that okay?

It shouldn't as it's only done if the ref is marked as dying.

>> +       smp_mb__after_atomic();
>> +
>> +       while ((node = llist_del_all(&data->put_llist)) != NULL) {
>> +               llist_for_each_entry_safe(file, tmp, node, f_u.fu_llist)
>> +                       io_ring_file_put(data->ctx, file);
>> +       }
> 
> Why "while"? You expect someone to place new stuff on the ->put_llist
> while in the llist_for_each_entry_safe() loop and don't want to wait
> for the next execution of io_ring_file_ref_switch()? Or am I missing
> something here?

I just see it as good practice to avoid the case where later additions
are missed, and we end up racing with addition + check. Probably not
needed!

>> +       percpu_ref_switch_to_percpu(&data->refs);
>> +       if (percpu_ref_is_dying(&data->refs))
>> +               complete(&data->ctx->completions[2]);
>> +}
>> +
>> +static void io_file_data_ref_zero(struct percpu_ref *ref)
>> +{
>> +       struct fixed_file_data *data;
>> +
>> +       data = container_of(ref, struct fixed_file_data, refs);
>> +       if (test_and_set_bit_lock(0, (unsigned long *) &data->ref_work.files))
>> +               return;
> 
> You're reusing the low bit of a pointer field in io_wq_work as an
> atomic flag? If I understand correctly, io_ring_file_ref_switch work
> items just use that field to store this flag and don't use it as a
> pointer, right? In that case, shouldn't the field be a union instead
> of using such a cast? (You could make it an unnamed union if you're
> worried about having to rename stuff everywhere.)

Right, it's just an available member we can use, as ->files is only used
if IO_WQ_WORK_NEEDS_FILES is set on the work structure. I'll turn it
into an anon union, it was just a quick'n dirty.

>> +       if (!llist_empty(&data->put_llist)) {
>> +               percpu_ref_get(&data->refs);
>> +               io_wq_enqueue(data->ctx->io_wq, &data->ref_work);
>> +       } else {
>> +               clear_bit_unlock(0, (unsigned long *) &data->ref_work.files);
>> +               if (percpu_ref_is_dying(&data->refs))
>> +                       complete(&data->ctx->completions[2]);
>> +       }
>> +}
>> +
>>  static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>                                  unsigned nr_args)
>>  {
>>         __s32 __user *fds = (__s32 __user *) arg;
>>         unsigned nr_tables;
>> +       struct file *file;
>>         int fd, ret = 0;
>>         unsigned i;
>>
>> -       if (ctx->file_table)
>> +       if (ctx->file_data)
>>                 return -EBUSY;
>>         if (!nr_args)
>>                 return -EINVAL;
>>         if (nr_args > IORING_MAX_FIXED_FILES)
>>                 return -EMFILE;
>>
>> +       ctx->file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
>> +       if (!ctx->file_data)
>> +               return -ENOMEM;
>> +       ctx->file_data->ctx = ctx;
>> +
>>         nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
>> -       ctx->file_table = kcalloc(nr_tables, sizeof(struct fixed_file_table),
>> +       ctx->file_data->table = kcalloc(nr_tables,
>> +                                       sizeof(struct fixed_file_table),
>>                                         GFP_KERNEL);
>> -       if (!ctx->file_table)
>> +       if (!ctx->file_data->table) {
>> +               kfree(ctx->file_data);
>> +               ctx->file_data = NULL;
>>                 return -ENOMEM;
>> +       }
>> +
>> +       if (percpu_ref_init(&ctx->file_data->refs, io_file_data_ref_zero,
>> +                               PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> +               kfree(ctx->file_data->table);
>> +               kfree(ctx->file_data);
>> +               ctx->file_data = NULL;
>> +       }
>> +       ctx->file_data->put_llist.first = NULL;
>> +       INIT_IO_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
>> +       ctx->file_data->ref_work.flags = IO_WQ_WORK_INTERNAL;
> 
> Why are you punting the ref switch onto a workqueue? Is this in case
> the refcount is still in the middle of switching from percpu mode to
> atomic?

Exactly, if we're already switching then we need to be able to block.
What I really need is a percpu_ref_switch_to_atomic_if_not_atomic(), and
this also ties into the __percpu_ref_is_percpu() further down.

>>         if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
>> -               kfree(ctx->file_table);
>> -               ctx->file_table = NULL;
>> +               percpu_ref_exit(&ctx->file_data->refs);
> 
> You call percpu_ref_exit() in this failure path, but nowhere else?
> That seems to me like it implies at least a memory leak, if not worse.

Yeah that's missing, thanks! I'll fix that up.

>> +               kfree(ctx->file_data->table);
>> +               kfree(ctx->file_data);
>> +               ctx->file_data = NULL;
>>                 return -ENOMEM;
>>         }
>>
>> @@ -4015,13 +4191,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>                         continue;
>>                 }
>>
>> -               table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
>> +               table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>>                 index = i & IORING_FILE_TABLE_MASK;
>> -               table->files[index] = fget(fd);
>> +               file = fget(fd);
>>
>>                 ret = -EBADF;
>> -               if (!table->files[index])
>> +               if (!file)
>>                         break;
> 
> Not new in this commit, but it seems kinda awkward to have to
> open-code the table lookup here... this might be nicer if instead of
> "struct file *io_file_from_index(...)", you had "struct file
> **io_file_ref_from_index(...)".

Agree, that would be a good helper to add. I'll do that as a prep patch.

>>                 /*
>>                  * Don't allow io_uring instances to be registered. If UNIX
>>                  * isn't enabled, then this causes a reference cycle and this
>> @@ -4029,26 +4206,26 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>>                  * handle it just fine, but there's still no point in allowing
>>                  * a ring fd as it doesn't support regular read/write anyway.
>>                  */
>> -               if (table->files[index]->f_op == &io_uring_fops) {
>> -                       fput(table->files[index]);
>> +               if (file->f_op == &io_uring_fops) {
>> +                       fput(file);
>>                         break;
>>                 }
>>                 ret = 0;
>> +               WRITE_ONCE(table->files[index], file);
> 
> Why WRITE_ONCE()? There are no readers who can see the file at this
> point, right?

Agree

>> @@ -4197,15 +4315,15 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>>                         break;
>>                 }
>>                 i = array_index_nospec(up.offset, ctx->nr_user_files);
>> -               table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
>> +               table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>>                 index = i & IORING_FILE_TABLE_MASK;
>>                 if (table->files[index]) {
>> -                       io_sqe_file_unregister(ctx, i);
>> -                       table->files[index] = NULL;
>> +                       file = io_file_from_index(ctx, index);
>> +                       llist_add(&file->f_u.fu_llist, &data->put_llist);
> 
> How can it be safe to implement this with a linked list through a
> member of struct file? What happens if someone, for example, uses the
> same file in two different uring instances and then calls this update
> helper on both of them in parallel? file->f_u.fu_llist will be put on
> one list, and then, without removing it from the first list, be
> connected to the second list, right? At which point the two lists will
> be weirdly spliced together.

Hmm yes, I guess that won't work if it ends up being the same struct
file pointer. I guess a more straightforward case would be registering
the same file twice in a set.

>> @@ -4234,6 +4352,11 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
>>                 up.offset++;
>>         }
>>
>> +       if (did_unregister && __ref_is_percpu(&data->refs, &percpu_count)) {
>> +               percpu_ref_put(&data->refs);
>> +               percpu_ref_switch_to_atomic(&data->refs, NULL);
>> +       }
> 
> There's a comment on __ref_is_percpu() saying "Internal helper.  Don't
> use outside percpu-refcount proper.", and it is some lockless helper
> thing that normally only has a meaning when used inside an RCU-sched
> read-side critical section. If you want to use that helper outside the
> internals of percpu-refcount, I think you'll have to at least change
> the documentation of that helper and document under which conditions
> it means what.

I know and did notice that, again just a quick'n dirty as a proof of
concept. For this to get cleaned up, we'd need something that just
switches to atomic mode IFF we're in percpu mode and not already on the
way to atomic.

> But I also don't really understand the intent here. It looks like the
> idea is that if we've just removed a file from the uring instance, we
> want to detect when the number of pending I/O items that use files is
> at zero so that we can throw away our reference to the file? And we
> hope that we're somehow protected against concurrent mode switches
> (which would mean that we must somehow be protected against concurrent
> io_ring_file_ref_switch())?

Exactly

> I wonder whether an alternative scheme might be that instead of having
> the percpu refcounting logic for the entire file table and keeping
> files open until no file I/O is being executed for a moment, you could
> iterate through all pending work items (including ones that are
> currently being executed) under appropriate locks, and if they use
> fixed files that are to-be-removed, flip the type to non-fixed and
> increment the file's refcount?

There's no way to iterate all the current work items for all op code
types, but yes that would be a much simpler solution. We really just
need to ensure that nobody has a request inflight against a fixed file.
The flip-to-normal solution is tempting, but it'd be problematic in
terms of overhead to be able to do this safely and completely, not
missing anything.

I'm going to re-think bits of this, thanks for your review!

-- 
Jens Axboe

