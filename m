Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078194F68DB
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbiDFSDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240572AbiDFSDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 14:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 491211A54F9
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 09:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649263090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8DamHq4OnsvOgi0NkHszsuoM86MaPcdsuYT+qyyhLx8=;
        b=VCTd9WCQjIbVetcjwpItTD3O6g6UAgl6XZRfCSKI02Bp4RvA3O+QK9S7UduEnfrXSnklto
        vO3CyUSuwj4+6HPAASbgNqT/zyjxckUC8oOM67VDfZAws4G5TWxgtkSh5p6sVvzVeSLv0V
        GUvDKgHTJgwEvyIADd0lSxqajEEGY/4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-dxmyFy9xPEaeVFqdzjiF2w-1; Wed, 06 Apr 2022 12:38:09 -0400
X-MC-Unique: dxmyFy9xPEaeVFqdzjiF2w-1
Received: by mail-qt1-f197.google.com with SMTP id f3-20020ac84983000000b002e22396acfbso3385596qtq.18
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 09:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8DamHq4OnsvOgi0NkHszsuoM86MaPcdsuYT+qyyhLx8=;
        b=pfwemzMdUq5OT9C4+2ydYXlRQe1zoZ7fiAtbdJqNvuDf00FYIH0gKjIWJ4F+kjzU7h
         8Kc0/lvzfRMf/wyTQv94UHOR6Pgbbu9t5o5DvJIWePpViPPSFrGB4aEOVJaJQNwLF1R8
         lgNoRYmkOaPa0wH7Y6D7SWComRaRCNynINtlUKHUflCaDMKGNrXqiufNQLoLxumlgUQn
         Zf/g6Cw7lXS5KhgQoUhZ+R8HkPCaRo6NImnVzRIkYPfdTPbpe1N5Q7RHV+XAM0NLRC8X
         SLlgCH7S36OL1R3u4YQHGLq4LdYmY8ZIcW+XS6ChttHU1ZlyrKtsWRcm8Vd7YqEY3+JH
         jcyg==
X-Gm-Message-State: AOAM533rgjDYy6ymNud49LORpBYmXBlRTzcrUBUEoKGMU0jDTXF7x47V
        S2NeX5OdaFVGTBbnHglsKPZb7et+kps6PPpP2Ei9V4UsafGClqaHgIv0ZWPVsXlYZeE22peBlAP
        GVKMn4Fem7hoWfpjdoQ==
X-Received: by 2002:ac8:59c3:0:b0:2e1:a305:cc6 with SMTP id f3-20020ac859c3000000b002e1a3050cc6mr8257307qtf.429.1649263088760;
        Wed, 06 Apr 2022 09:38:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/4Yz9i6gGwd8BDifo/GXM6S6qpXAkRAUstMbBfcS50KppxW+sS4Edzskpyl4dKkbJ9GBZuQ==
X-Received: by 2002:ac8:59c3:0:b0:2e1:a305:cc6 with SMTP id f3-20020ac859c3000000b002e1a3050cc6mr8257286qtf.429.1649263088510;
        Wed, 06 Apr 2022 09:38:08 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id j4-20020a37c244000000b0067d79a3fd0esm10443617qkm.106.2022.04.06.09.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 09:38:08 -0700 (PDT)
Date:   Wed, 6 Apr 2022 12:38:06 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Mike Snitzer <snitzer@kernel.org>
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Message-ID: <Yk3B7pY8/gYS856a@redhat.com>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <f2819e9f-4445-5c5a-2a68-1d85f4bc341a@kernel.dk>
 <Yk0PlfaGooaFdvmm@T590>
 <a211438e-5268-ba62-dd45-ad7b72a48ed5@kernel.dk>
 <Yk2T9CEGwgq90lo9@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk2T9CEGwgq90lo9@T590>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 06 2022 at  9:21P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Wed, Apr 06, 2022 at 06:58:28AM -0600, Jens Axboe wrote:
> > On 4/5/22 9:57 PM, Ming Lei wrote:
> > > On Tue, Apr 05, 2022 at 08:20:24PM -0600, Jens Axboe wrote:
> > >> On 4/3/22 5:45 AM, Ming Lei wrote:
> > >>> -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> > >>> set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> > >>> io_iopoll_check doesn't handle this situation, and io hang can be caused.
> > >>>
> > >>> Current dm io polling may return -EAGAIN after bio submission is
> > >>> returned, also blk-throttle might trigger this situation too.
> > >>
> > >> I don't think this is necessarily safe. Handling REQ_F_ISSUE from within
> > >> the issue path is fine, as the request hasn't been submitted yet and
> > >> hence we know that passed in structs are still stable. Once you hit it
> > >> when polling for it, the io_uring_enter() call to submit requests has
> > >> potentially already returned, and now we're in a second call where we
> > >> are polling for requests. If we're doing eg an IORING_OP_READV, the
> > >> original iovec may no longer be valid and we cannot safely re-import
> > >> data associated with it.
> > > 
> > > Yeah, this reissue is really not safe, thanks for the input.
> > > 
> > > I guess the only way is to complete the cqe for this situation.
> > 
> > At least if
> > 
> > io_op_defs[req->opcode].needs_async_setup
> > 
> > is true it isn't safe. But can't dm appropriately retry rather than
> > bubble up the -EAGAIN off ->iopoll?

The -EAGAIN is happening at submission, but this is bio-based so it is
felt past the point of ->submit_bio return.  The underlying
request-based driver has run out of tags and so the bio is errored by
block core. So it isn't felt until bio completion time.

In the case of DM, that stack trace looks like:

[168195.924803] RIP: 0010:dm_io_complete+0x1e0/0x1f0 [dm_mod]
<snip>
[168196.029002] Call Trace:
[168196.031543]  <TASK>
[168196.033737]  dm_poll_bio+0xd7/0x170 [dm_mod]
[168196.038106]  bio_poll+0xe3/0x110
[168196.041435]  iocb_bio_iopoll+0x34/0x50
[168196.045278]  io_do_iopoll+0xfb/0x400
[168196.048947]  io_iopoll_check+0x5d/0x140
[168196.052873]  __do_sys_io_uring_enter+0x3d9/0x440
[168196.057578]  do_syscall_64+0x3a/0x80
[168196.061246]  entry_SYSCALL_64_after_hwframe+0x44/0xae

But prior to that, the DM clone bio's ->bi_end_io (clone_endio) was
called with BLK_STS_AGAIN -- its just that by design dm's ->poll_bio
is what triggers final dm_io_complete() of the original polled bio (in
terms of polling process's context).

> The thing is that not only DM has such issue.
> 
> NVMe multipath has the risk, and blk-throttle/blk-cgroup may run into such
> situation too.
> 
> Any situation in which submit_bio() runs into async bio submission, the
> issue may be triggered.

bio-based is always async by virtue of bios getting packed into a
request kafter ->submit_bio returns. But to do so an available tag is
needed.

Mike

