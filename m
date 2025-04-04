Return-Path: <io-uring+bounces-7388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A55A7B564
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 03:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1EC31744AD
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 01:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8A28F5C;
	Fri,  4 Apr 2025 01:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LGrV44Zi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fTQ2AXL1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LGrV44Zi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fTQ2AXL1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B5BC8FE
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 01:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743729503; cv=none; b=fmDwuIpqClkiWjQuom+x/yFixcObo1k8ejYd+liKl7LFHu7ZUmxmND4VuHnzJJrzEFvFOfUKU505PHOwKt+vdgXy4yUEcBFm7o2yNWP8IEf1QtAgQDTPRFNHJld4eJ198JTy/59caM1puYfoWw+nnfKzi03uXKYwXu4jAUU3oiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743729503; c=relaxed/simple;
	bh=Y6KdQ1Bc4GBVEN6KJXTbRxHmSBRwRSWsbl3Vng1tZIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AUzDusgDyPxOC/LVj9fiicU61OzN6mnnMNdzMp49R7hBvqLpv307G40U8ffk3KfxoiSmpoC4HvCkBuj2IHi0aziZaVty1TA6TIvaCn/+eLw1Ms68Fw4QUH7oZVr+Vc79q4ccm0HlRnfyuNiNjjP5u5o5ZVTbeMNoQ53H7KS5DbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LGrV44Zi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fTQ2AXL1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LGrV44Zi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fTQ2AXL1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9521211A5;
	Fri,  4 Apr 2025 01:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743729497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSNBrprBzOaZrLxbv/dh5MDZsrUs70sm/59jdSyXcfc=;
	b=LGrV44Zig5RcgoweaoRRgQZ8EE+HhUvWKD80KYGIuvRbCGC4m8AIcdrf/QZGSSScNb6CEw
	HbN7pzk/2j/YmspZ7oI9T2iAkOgsFM9DC5rspXWmZLpKddYaLGKZ3YwoPVTgEXriUzTciN
	Ulou8zlCG4yx3dQBP4YjTkaZgaPNe78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743729497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSNBrprBzOaZrLxbv/dh5MDZsrUs70sm/59jdSyXcfc=;
	b=fTQ2AXL1su85ra6axt8xOb69fj0DQyJVY5HYq3QtvRFVCmBFVfnicNbBLFSrLWYGt0GUVy
	7aNHEGmSdIrHQHDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743729497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSNBrprBzOaZrLxbv/dh5MDZsrUs70sm/59jdSyXcfc=;
	b=LGrV44Zig5RcgoweaoRRgQZ8EE+HhUvWKD80KYGIuvRbCGC4m8AIcdrf/QZGSSScNb6CEw
	HbN7pzk/2j/YmspZ7oI9T2iAkOgsFM9DC5rspXWmZLpKddYaLGKZ3YwoPVTgEXriUzTciN
	Ulou8zlCG4yx3dQBP4YjTkaZgaPNe78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743729497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jSNBrprBzOaZrLxbv/dh5MDZsrUs70sm/59jdSyXcfc=;
	b=fTQ2AXL1su85ra6axt8xOb69fj0DQyJVY5HYq3QtvRFVCmBFVfnicNbBLFSrLWYGt0GUVy
	7aNHEGmSdIrHQHDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7819E13691;
	Fri,  4 Apr 2025 01:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YAIvEVkz72dFCAAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 04 Apr 2025 01:18:17 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring/sqpoll: Increase task_work submission batch size
In-Reply-To: <94da2142-d7c1-46bb-bc35-05d0d1c28182@kernel.dk> (Jens Axboe's
	message of "Thu, 3 Apr 2025 14:26:40 -0600")
Organization: SUSE
References: <20250403195605.1221203-1-krisman@suse.de>
	<94da2142-d7c1-46bb-bc35-05d0d1c28182@kernel.dk>
Date: Thu, 03 Apr 2025 21:18:15 -0400
Message-ID: <87friod8rs.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Jens Axboe <axboe@kernel.dk> writes:

> On 4/3/25 1:56 PM, Gabriel Krisman Bertazi wrote:
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
>> -#define IORING_TW_CAP_ENTRIES_VALUE	8
>> +#define IORING_TW_CAP_ENTRIES_VALUE	1024
>
> That's a huge bump! This should not be a submission side thing, it's
> purely running the task work. For this test case, I'm assuming you don't
> see any io-wq activity, and hence everything is done purely inline from
> the SQPOLL thread?
> This confuses me a bit, as this should not be driving
> the queue depth at all, as submissions would be done by
> __io_sq_thread().

Indeed, the submission happens fully inside __io_sq_thread, and I can
confirm that from the profile.  What is interesting is that, once I lift
the cap, we end up spending more time inside io_submit_sqes, which means
it is able to drive more requests.

Let me share the profile in case it rings a bell:

This is perf-record on a slow kernel:

   - 49.30% io_sq_thread
      - 41.86% io_submit_sqes
         - 20.57% io_issue_sqe
            - 19.89% io_read
               - __io_read
                  - 18.19% blkdev_read_iter
                     - 17.84% blkdev_direct_IO.part.21
                        + 7.25% submit_bio_noacct_nocheck
                        + 6.49% bio_iov_iter_get_pages
                        + 1.80% bio_alloc_bioset
                          1.27% bio_set_pages_dirty
                  + 0.78% security_file_permission
         - 10.88% blk_finish_plug
            - __blk_flush_plug
               - 10.80% blk_mq_flush_plug_list.part.88
                  + 10.69% null_queue_rqs
           0.83% io_prep_rw
      - 4.11% io_sq_tw
         - 3.62% io_handle_tw_list
            - 2.76% ctx_flush_and_put.isra.72
                 2.67% __io_submit_flush_completions
              0.58% io_req_rw_complete
      + 1.15% io_sq_update_worktime.isra.9
        1.05% mutex_unlock
      + 1.05% getrusage

After my patch:

   - 50.07% io_sq_thread
      - 47.22% io_submit_sqes
         - 38.04% io_issue_sqe
            - 37.19% io_read
               - 37.10% __io_read
                  - 34.79% blkdev_read_iter
                     - 34.34% blkdev_direct_IO.part.21
                        + 21.01% submit_bio_noacct_nocheck
                        + 8.30% bio_iov_iter_get_pages
                        + 2.21% bio_alloc_bioset
                        + 1.52% bio_set_pages_dirty
                  + 1.19% security_file_permission
         - 3.29% blk_finish_plug
            - __blk_flush_plug
               - 3.27% blk_mq_flush_plug_list.part.88
                  - 3.25% null_queue_rqs
                     + null_queue_rq
           1.16% io_prep_rw
      - 2.25% io_sq_tw
         - tctx_task_work_run
            - 2.00% io_handle_tw_list
               - 1.08% ctx_flush_and_put.isra.72
                    1.07% __io_submit_flush_completions
                 0.68% io_req_rw_complete

> And that part only caps when there is more than a
> single ctx in there, which your case would not have. IOW, it should
> submit everything that's there and hence this change should not change
> the submission/queueing side of things. It only really deals with
> running the task_work that will post the completion.
>
> Maybe we should just not submit more until we've depleted the tw list?
>
> In any case, we can _probably_ make this 32 or something without
> worrying too much about it, though I would like to fully understand why
> it's slower. Maybe it's the getrusage() that we do for every loop? You
> could try and disable that just to see if it makes a difference?

While the overhead of the usage accounting is very visible in the
profile, my first test when I got this bug was to drop that code, and it
had very little impact on throughput (around 1%).  The main difference
really seems to be around the number of ios we queue per iteration. In
fact, looking at iostat, I can see a very noticeable difference in
aqu-sz between both kernels.

A lower limit should work, yes, but I'm also quite curious how the tw
affects the submission. But also, what is the reason to cap it in the
first place?  io_handle_tw_list does a cond_reesched() on each
iteration, so it wont hog to the cpu and, if we drop the cap, we'll have
the behavior of not submitting more until the tw list is empty, as you
suggested.

-- 
Gabriel Krisman Bertazi

