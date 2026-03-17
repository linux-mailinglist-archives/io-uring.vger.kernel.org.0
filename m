Return-Path: <io-uring+bounces-12724-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJJCOOlTuWnYAgIAu9opvQ
	(envelope-from <io-uring+bounces-12724-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 14:15:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F34A02AAA7F
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 14:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 866AD31C321B
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 13:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842D43A5E71;
	Tue, 17 Mar 2026 13:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tbtbq6t/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F89F322B83
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752873; cv=none; b=RH2sDykVjnZ0uq9UkUozsSdpgRTKDc5lfNjjkwmSffESybE5tvCdz9QqaMJJyPhFaKUWgN5StxhoTHkVY2D3hDopeYOtZxqtX4XedNp8SVYV9EwBcEL+jr4OCyGfV3G1o9pBBn8BWB2HI2sh/g1X5nfhs537ise3CY7YkmAzq4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752873; c=relaxed/simple;
	bh=FuuGyPMBk9LaFdkIhdNqG9dyY9iRKefDYLs56L7ca20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gCMQuLgjq7bdyYfP01IL4ykf0cYX6t+19OAIjyKBV2sU7zHGcZJMOgzQ9L2xxKGv54m+l/PA/Dk53GAs+0JleS2ozbMg1p7LLoH2VxSEkqHP0N0Ezr+1lAJ2hthej+Gt8+YxA0pytLoW80syEEw+VjOSVMsmg/Aw7ZCMv83jgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tbtbq6t/; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4645dde00a7so539471b6e.1
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773752869; x=1774357669; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kwBFrY3Va9qlr3Dh5hZm0gxRMuyj4lMPF89cw5/AwPw=;
        b=tbtbq6t/faBldVSw7a1+LrRDLtIshEBBQx+eP1YmSeJ/dOX3+QnaD5+BrVcieZ7F2j
         IBPLaDhyjUNReB/hq1hE0CE2DRJLgI4WK+C6AfKulNHv//o0i66VEBmK4eQgEhp3jRMk
         Y8lmHoXX9AGwnuyg94tcy6UTVRx6/b0zYHwOKIBWv6G4ps1coGu5+kKNEf9TG0h6qxNG
         BhisMuQZqKmCZyVZVCecvMSTQYOqueKz3fP8QpMEYAY3o3/dXZna1PgjmAVbhI+JsmfT
         biMOyVFQxFnLWD9mTBebm74ZD/RzhMq/9VRaZVfkoBeVCt182HT/5dgp06E8loURnuBD
         fi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773752869; x=1774357669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwBFrY3Va9qlr3Dh5hZm0gxRMuyj4lMPF89cw5/AwPw=;
        b=Nqtw1puL0zm+FONzoDNXXOnic9TsH6ldh2vfoQ6WrV17kbifxr19Ofs5Y2FHM2AuZn
         RHxyOXkecJScQZB42YedsIRxReKvZ+WSQdgRXtNVi2Zopzo24+rgFWW9ekDmRJx1LwZQ
         lH4G2tWIynlSzO4GfUS2plV4piQ5/NFB+KqlxjZbMyY8L7k0UPLknCVpm7xalR3FvxrX
         s5h3VNwJg8dBBxFCaW3u71SI/CQtQIdouG7Bk5pqAVYQdRl1yI5fmv1nRlzQfwMdV5eP
         QYBr01P9OWGIws89sBNHQwD0C9PK977VW1ua6n3En7Mlgr4RdE4QgX3GwBX5TmccWD3X
         MDVw==
X-Forwarded-Encrypted: i=1; AJvYcCWKwNDZuBgvYSItn6MNDZmFsiPrscC6ANEy6Jr7wzq5O8Oo58plUa+Bo/xN/HP6l04YFuStFFWuHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyalutCKB/utuhV9m0OBEHs+H640moSlDiXGcnFBNlOuh2W34h3
	7nVR8hSzkNnNrC2735G8u8oaBWE3ZmJ8DWpusE4jy8sYYzDvnf/SD0NbysHPIFcW1E0omFmEwPg
	fFxXTCJc=
X-Gm-Gg: ATEYQzw5S2x7U/ZSjVw/D9yS4mprtA7SUv7c9WbuUMug+CfJ8PMdv3n5ahpvRvMiuaY
	MhLBBndwugDf5G0xBd7lskhVtt5nxFI53fQ488m4PgHXht84ksjDgwMx51CEcPBwLvDK8GSTi9+
	KgxFmOUmyhVdZIiPoer0N2NU/JIEUUq0TbJyRugZn3T24aXozjMao3UbWpSBrYtBsbjwSOscHMZ
	GjXlaz9LlZgnno98Zi59MesqXoIUBo/1Um5eNMLaKIUGEE4PRZuwUm2s+bdrhKIK8diVi1l8p26
	ME9JMV3UWO+RUWX7jGzWxNPgJIOHn+4HyrkRXeX/A8POIBuDCtce5w53P/nl30iN1fxTOxwtfsW
	2rpau4j8HXlS4bQ/8sjQUskljX7/Jg2UFePZPQ0JKDZc0EknzyxUYoSy5ZRqH60atBhlYq3ERJ1
	cb5BGg4et/Pqk6ZIxNK73LLas2xiD7r1o6cIsDbAoOoWM2i2AAM4VS2GogUuVyC3iGYATTRd7ie
	wiVd/gZ0Q==
X-Received: by 2002:a05:6808:5087:b0:45e:b4c2:ff58 with SMTP id 5614622812f47-467a7f77daamr1860827b6e.10.1773752869270;
        Tue, 17 Mar 2026 06:07:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4673415d291sm11203106b6e.6.2026.03.17.06.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 06:07:48 -0700 (PDT)
Message-ID: <edcd0d75-6877-409d-8350-915349395a7c@kernel.dk>
Date: Tue, 17 Mar 2026 07:07:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Francis Brosseau <francis@malagauche.com>
References: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
 <06a8b8a6-2cf0-4d1f-835f-06f4070402d9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <06a8b8a6-2cf0-4d1f-835f-06f4070402d9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12724-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: F34A02AAA7F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 6:27 AM, Pavel Begunkov wrote:
> On 3/17/26 02:17, Jens Axboe wrote:
>> When a socket send and shutdown() happen back-to-back, both fire
>> wake-ups before the receiver's task_work has a chance to run. The first
>> wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
>> When io_poll_check_events() runs, it calls io_poll_issue() which does a
>> recv that reads the data and returns IOU_RETRY. The loop then drains all
>> accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
>> the first event was consumed. Since the shutdown is a persistent state
>> change, no further wakeups will happen, and the multishot recv can hang
>> forever.
>>
>> Check specifically for HUP in the poll loop, and ensure that another
>> loop is done to check for status if more than a single poll activation
>> is pending. This ensures we don't lose the shutdown event.
> 
> Sounds fine with comments below.

Thanks

> Btw, did you look into whether it's a INQ issue? Polling expects
> multishots to handle all those conditions, which usually goes in a
> form of:
> 
> while (1) {
>     ret = do_IO();
>     if (ret == -EAGAIN)
>         goto continue_poll;
>     if (ret < 0)
>         goto fail;
>     if (ret == 0)
>         goto terminate_req;
>     ...
>     // partial progress, try again
> }
> 
> and recv was following this pattern before, but maybe it's sth
> like recv() returning some bytes, inq rightfully saying that there
> are no more bytes left but forgets to check for terminators like
> shutdown.

Right, as per my earlier emails, this is what introduced the issue for
AF_UNIX, when the INQ support was added. We read the whole thing, and
INQ is correctly returned as having 0 bytes left. Hence no retry
happens, and the EOF is missed. We could do something ala the below,
entirely untested, which would ensure we retry for that condition.

I don't love the poll HUP hack, but I also don't really like how the
poll event handling will coalesce the events effectively. Since this
particular issue will need to go back to 6.17+ stable, I'm also open to
doing the HUP hack and just doing something cleaner on top.

diff --git a/io_uring/net.c b/io_uring/net.c
index 3f9d08b78c21..c10d4c9bd88b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -903,10 +903,13 @@ static inline bool io_recv_finish(struct io_kiocb *req,
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
 	    io_req_post_cqe(req, sel->val, cflags | IORING_CQE_F_MORE)) {
+		struct socket *sock = sock_from_file(req->file);
+
 		sel->val = IOU_RETRY;
 		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0 ||
+		    READ_ONCE(sock->sk->sk_shutdown) & SHUTDOWN_MASK) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY &&
 			    !(sr->flags & IORING_RECV_MSHOT_CAP)) {
 				return false;

>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index aac4b3b881fb..a264d73a8cbd 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -228,6 +228,19 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
>>           __io_poll_execute(req, res);
>>   }
>>   +static inline void io_mshot_check_retry(struct io_kiocb *req, int *v)
>> +{
>> +    /*
>> +     * Release all references, retry if someone tried to restart
>> +     * task_work while we were executing it.
>> +     */
> 
> This comment belongs to the atomic sub, not masking.

True, should've left that there.

>> +    *v &= IO_POLL_REF_MASK;
> 
> nit: seems like you can just do that inside the
> "if (unlikely(v != 1)) { ... }" block.

That could work, then we don't need it in both the other branches.

>> +    /* multiple refs and HUP, ensure we loop once more */
>> +    if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && *v != 1)
>> +        (*v)--;
>> +}
>> +
>>   /*
>>    * All poll tw should go through this. Checks for poll events, manages
>>    * references, does rewait, etc.
>> @@ -303,6 +316,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>>                   io_req_set_res(req, mask, 0);
>>                   return IOU_POLL_REMOVE_POLL_USE_RES;
>>               }
>> +            v &= IO_POLL_REF_MASK;
>>           } else {
>>               int ret = io_poll_issue(req, tw);
>>   @@ -312,16 +326,11 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>>                   return IOU_POLL_REQUEUE;
>>               if (ret != IOU_RETRY && ret < 0)
>>                   return ret;
>> +            io_mshot_check_retry(req, &v);
> 
> Should go before io_poll_issue(), req->cqe.res might already be
> invalid.

Yeah good point, it was above it before. Too much late night
consolidation...


-- 
Jens Axboe

