Return-Path: <io-uring+bounces-12314-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oI8xF43nlWnKWAIAu9opvQ
	(envelope-from <io-uring+bounces-12314-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:23:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8287A157B1F
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 17:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DB8233002D2E
	for <lists+io-uring@lfdr.de>; Wed, 18 Feb 2026 16:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3844341670;
	Wed, 18 Feb 2026 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pLusIHFP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769F3334682
	for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771431812; cv=none; b=aYZZdLt8xsvsruGu0RfVk+AjLvqTgEBAr5Lk3kbs/AfsxDv0NzUT2mWNsSGsyE5Q8dyzHXY8sDdqemQZZy82h0o1GHz7lFHN9IYy2uHd1fNW39prxkVNuO0IRM5RR1UdKDXOGCIy57vscJVITWQ0xie3xcU3nhScza9yTviVyqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771431812; c=relaxed/simple;
	bh=bfZFhcAHRhPkfVVfhaEXA5gLrHD+Zf+8i41XB0DkCqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MspA50+gNrzBVCALhRu/KD8VCqsU7c8CQzOYavwTSM2//udliWsS4ZEerPBgElia7Gyo3pHxmhMguCOapJN79Xgd/QAe0BLEMqeeAGoYKxaG5F/rLEWoEajGemghoHBgFaxin76rKXJvg4anJgD4y7m9ZK3O08nRxhM9gUbTt2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pLusIHFP; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8954c9daaeaso76017726d6.1
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 08:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771431808; x=1772036608; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P6FnkwjeY6brj0/7CWbwbk4xYyhWl9xXSqqcuyfPR0w=;
        b=pLusIHFPzxd0YRj1NcTuDwiWy+9zQm73TqYATk0nte4kKPJ8T7LYrqZEayQQAVVbMa
         aedQyHB3DAKzlDzgtAJ8sMQZBBUUhF2nT0u1OJD3SihGpvjFVgZNDhbS3qOg+BlUypQ9
         9LbN6mGr5P9YpIrrZRJ+3darWlzkQQicV0rs7F05sPIe3RXI6fLvsph284AGWSHAqwBq
         WV6Wco+L57UwQdk4JdhVScHRuq8BSWCEielOnLB+fYDeM0F7JvmiXZASuli0sFLFDT1G
         Ghth0gmRsX3L/bVgDBOvm/GR/lZZfI5Avm11wSPH+kAW2x2ifgaXA+UTKvgHtJgTiyFR
         8P+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771431808; x=1772036608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P6FnkwjeY6brj0/7CWbwbk4xYyhWl9xXSqqcuyfPR0w=;
        b=GG8FsMnYBLrNHoHzgYcAxUbdkuTs9P6UujaT+dCRhZ4xxFjBaoVGZo+Lnoqwa2tlp8
         CufbHAkhowbRqdwf39SZnn5SzDJHaU8dZkU50tJpemV70/OP3/iA9lkg4yhmJYnaALB5
         /6KqWbDs6w0kmRm1tlews3hnNRrQaLumluKS8xPHGYcUcyH0Wt+IbDWUqJbdo6cx2hsd
         tFxWoNRycuSIgBKh7WzCdoYzW0XZZDIFJM1hRnGMUAtaCGwxzn8rxjZFHR4h+Sd0Fpwz
         SB+RYAvQHHp445UBYH+6r9Qai/CIuFgypS6eF6qZf2rPaTOePRUtI75WSWsEMIBGHumV
         vLIw==
X-Gm-Message-State: AOJu0YyqVT05XKRcBTGEIS1+QQv02GhoRddQ11Elgt7y2X07sbc2o/Aj
	s8ojD1hCQZ/mmS9GJvkv51m9A97O2bo52lBahsajSSZ8wNkdWtPwAvmwBahRcz/0g/E=
X-Gm-Gg: AZuq6aI6+RE2CmqYPxbc8UrCnSUJiZyeLVmqppC0FTrFqj0imL+u4rNDcwmJKfX7ZNb
	TFhJDurUYk5mJrwv7hHafoVW9CruCMzb0YU/o3x14TP1KV+cwEGOQ/1n6t+WWOKU3YinhQl6PT+
	16u0wnIG0BGqBmUZx7xxUzt9Htd3pZG1HjySoEDbDz3NGVBVJsSyAHioqVOe+40L/JUhQPYmFxT
	y1dDFhlWNYbeL2WGALZnbCVWpkXwGuuGEg2IqPC94hc5lOgmdBAVr+0g+2neNaiKbwY+7y0v0zY
	lb0RYtIH4UTGsigmi7ntepVorrumSkxMJJEBRoOxgf+cBeXmk3RUk4De6jD2e77LMAW9ODFNg/c
	QTwVGgrxNSTgMPEs3j5osJ42uxEGo85cIv+xaKqXwFoiAw0n0XFBQBzju1+VU+Kh/x8TFvpZf6s
	u1DhKwj5zF8k6jiLWXTMLhApkowETaZWLfpg8P5R2aS4OGZIs=
X-Received: by 2002:a05:6214:d01:b0:894:85ee:63c7 with SMTP id 6a1803df08f44-89734917c48mr270391536d6.43.1771431807931;
        Wed, 18 Feb 2026 08:23:27 -0800 (PST)
Received: from [172.19.0.48] ([99.196.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc91eccsm189415026d6.13.2026.02.18.08.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 08:23:27 -0800 (PST)
Message-ID: <88260480-238c-497c-bccc-aa1023551668@kernel.dk>
Date: Wed, 18 Feb 2026 09:23:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260213032119.1125331-1-csander@purestorage.com>
 <20260213032119.1125331-3-csander@purestorage.com>
 <CADUfDZr+4hv-vm8my7kbKQG-2zoomG5a1y5Yt9fzxqbvSyPrSw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr+4hv-vm8my7kbKQG-2zoomG5a1y5Yt9fzxqbvSyPrSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12314-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8287A157B1F
X-Rspamd-Action: no action

On 2/17/26 7:18 PM, Caleb Sander Mateos wrote:
> On Thu, Feb 12, 2026 at 7:21?PM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
>>
>> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
>> requests issued to it to support iopoll. This prevents, for example,
>> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
>> zero-copy buffer registrations are performed using a uring_cmd. There's
>> no technical reason why these non-iopoll uring_cmds can't be supported.
>> They will either complete synchronously or via an external mechanism
>> that calls io_uring_cmd_done(), so they don't need to be polled.
>>
>> Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
>> even if their files don't implement ->uring_cmd_iopoll(). For these
>> uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
>> don't insert the request into iopoll_list, and take the
>> io_req_complete_defer() or io_req_task_work_add() path in
>> __io_uring_cmd_done() instead of setting the iopoll_completed flag. Also
>> allow io_uring_cmd_mark_cancelable() to be called on these uring_cmds.
>> Assert that io_uring_cmd_mark_cancelable() is only called on
>> non-IORING_SETUP_IOPOLL io_urings or uring_cmds to files that don't
>> implement ->uring_cmd_iopoll().
>>
>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
>> ---
>>  io_uring/io_uring.c  |  4 +++-
>>  io_uring/uring_cmd.c | 11 +++++------
>>  2 files changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index c45af82dda3d..4e68a5168894 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1417,11 +1417,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>
>>         if (ret == IOU_ISSUE_SKIP_COMPLETE) {
>>                 ret = 0;
>>
>>                 /* If the op doesn't have a file, we're not polling for it */
>> -               if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
>> +               if ((req->ctx->flags & IORING_SETUP_IOPOLL) &&
>> +                   def->iopoll_queue && (!io_is_uring_cmd(req) ||
>> +                                         req->file->f_op->uring_cmd_iopoll))
>>                         io_iopoll_req_issued(req, issue_flags);
>>         }
>>         return ret;
>>  }
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index ee7b49f47cb5..8df52e8f1c1b 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -108,12 +108,12 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>          * Doing cancelations on IOPOLL requests are not supported. Both
>>          * because they can't get canceled in the block stack, but also
>>          * because iopoll completion data overlaps with the hash_node used
>>          * for tracking.
>>          */
>> -       if (ctx->flags & IORING_SETUP_IOPOLL)
>> -               return;
>> +       WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL &&
>> +                    req->file->f_op->uring_cmd_iopoll);
>>
>>         if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
>>                 cmd->flags |= IORING_URING_CMD_CANCELABLE;
>>                 io_ring_submit_lock(ctx, issue_flags);
>>                 hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
>> @@ -165,11 +165,12 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
>>                 if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
>>                         req->cqe.flags |= IORING_CQE_F_32;
>>                 io_req_set_cqe32_extra(req, res2, 0);
>>         }
>>         io_req_uring_cleanup(req, issue_flags);
>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>> +       if (req->ctx->flags & IORING_SETUP_IOPOLL &&
>> +           req->file->f_op->uring_cmd_iopoll) {
> 
> I do worry that the pointer chasing here may be expensive, ->file and
> ->f_op could both be uncached. Would it make sense to add a flag to
> req->flags to indicate whether a request should actually be IOPOLLed?

I think adding a REQ_F flag for that similar to what is done for NOWAIT
etc would be a good idea.

-- 
Jens Axboe

