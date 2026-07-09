Return-Path: <io-uring+bounces-13924-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NdFkIuPeT2rkpQIAu9opvQ
	(envelope-from <io-uring+bounces-13924-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Jul 2026 19:48:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DBED6733F54
	for <lists+io-uring@lfdr.de>; Thu, 09 Jul 2026 19:48:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="bxOM1o/V";
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13924-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13924-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E14B330036EB
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2026 17:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023E14195D3;
	Thu,  9 Jul 2026 17:44:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1254195D0
	for <io-uring@vger.kernel.org>; Thu,  9 Jul 2026 17:44:42 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783619085; cv=none; b=kgvASjmSjQhO3wl/rUxuAK4bx5EmKEDliSV7R8b1hhI3gTdj9UOhs3SAveMSM8FdG6JvEIVg53JLL3qA6kFiDImv6K8Cv8Qqr7Di5WxOAm66TzzVyPcwN7wvkzUx/xWMfdW7tcCyptSHmoxFVnmR5hcHcp2BaFJQURVFmv7h0y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783619085; c=relaxed/simple;
	bh=SgnGZh3+lr4Pw7d9IlsRsrdooM2RWqSCNbEV2BVmwWg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XXU3nsluW5rD7ZQG3xCvfxez1imug8V+/ngAoqnbjK0YxChn6VKYlhaAwtEebBMUT5FnElko/l3t7f4Kb5lAOQovcntZBoPVkXR5yBv1O1sC+5IB+aGT1Fy1QKcmsiFx9img00vDBeFYClZajFc/3otsmQGJE8NS22d7kO3iNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bxOM1o/V; arc=none smtp.client-ip=209.85.210.53
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7eb4d532e65so77210a34.0
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2026 10:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783619082; x=1784223882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+46z3l8ubwsATKwGgExPOvEgJwrb0Yq0ua6HQJ/STk=;
        b=bxOM1o/VgSXBcWrudedsu1tn6uj3reE3XiEjI6bRyvboerNm3iW/A/i+E4SrpiA1HF
         gHQzS04mRHRxzirg6yHAw7JoTWnqijT15nUVgOxqob8nHi/S8GJANusP0LXRV9yY05Kb
         eiz7NBZyYt0jqjN8quonqirbTt1ykCzEd6Tx9GSEIMuOK4I//JltlgmWggiw0d/U1Z+R
         uf63sCyZo+i0uXvVAf+WlwHjKBsRCbEPoKupvH51mD6E5e68CRdPzJ8XZ8JnzkLPkLVU
         z7oB0VT44T9CzZTV2ZSsqacAnQGmB36jxhWAz6JG1vO5BOeIFndUhJwHFuBH84g5gKgb
         YxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783619082; x=1784223882;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c+46z3l8ubwsATKwGgExPOvEgJwrb0Yq0ua6HQJ/STk=;
        b=kk5sQOdLfUBQFOHoVPwvdobTBV3TJA7uYZZwlYeXotc7+l6u/3GfOjhEppGIJ15/ar
         +sx1f05v6LLlRFnlizQO2AJb9x8clbzPjBraLv5iH9GH7bo5rVicx+Dpdld6N7h0UsnQ
         mGAlBMCS380H8GgEOcOJcpnOQRetSYuB9m7qBCvd96c24fz4VZgxp9VdQ2Lehu0iR+aq
         o2sjxA1E0w8GUmooJuh+5HsR1ufgSV7sHQPFznHxaABVCuP8yOjFt/l3EcM8C1f5mA0v
         g4O8uUqaDjmPxJs7FeSVVpN8TUzQUUnvQ9ZZZH696dyudgFa2dPcLenqXLptsmRflE8P
         8cgQ==
X-Gm-Message-State: AOJu0YwD6YQMav/nyqmLPCkJS6ryCrQEO2ZrEVxOIcG48rkwdPHeATOT
	3EV2HLOf4o8pJE0YXPqOMt24XsRVCAURcpZh7ZrJkcqFQJ9/9dPY95P5MDjArM1H0e8=
X-Gm-Gg: AfdE7clJb0dSlszuy5V9rTO7JoIRhPpOCbl+501PmfN+xQ+xHNw6hXMzyLGf8D4dGfJ
	jALOelO99x6o2wJhIxr7eArJvluE8IgNSVyhxhUE1jmTurbZJ+D/kNVZg8m3++XA2ViinU943Bd
	gjNTcNcUipuBNNUbc3lmA67+3cfQ4h/wxLuILv1tQIR+n/Ypzf9GTq4oz2KHtUdWf7a1vGBnhLi
	SrowZ11Nvc8tBua7+WX9yydetLCTWtLZnDpVzuoQ/4KHj6Hmd9/PI4KbryJFAOBYZ/NfYGpe9/C
	YuKyc0wzU7d4dwEL6cK/ad4QZjC+iGw03hdzq6rC4oe7PY74yk/x5gjxK5sbiS63+NsVqk2r6f4
	iIEzTMoj2AI742i6hqgvS8DGksfewgvFeaJxUuDkRzQLpmjkrv3zOWNztcOrR63u2jZAGLueRj/
	O7eUet3Ok3BDLh53U8lsOvdCKB8AH6SWBePXo6cBFrJZ8POt2Q8UgqlMNbsx7d3Bp7XQ==
X-Received: by 2002:a05:6830:640f:b0:7e9:e488:3bce with SMTP id 46e09a7af769-7ebcfe5d817mr5221760a34.6.1783619081742;
        Thu, 09 Jul 2026 10:44:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcae20782sm4768052a34.4.2026.07.09.10.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:44:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Woraphat Khiaodaeng <worapat.kd2@gmail.com>
Cc: Jens Axboe <axboe@kernel.dev>
In-Reply-To: <20260709035100.2269-1-worapat.kd2@gmail.com>
References: <20260709035100.2269-1-worapat.kd2@gmail.com>
Subject: Re: [PATCH] io_uring: restore RCU read section in
 io_req_local_work_add()
Message-Id: <178361907941.14321.2989447050307137432.b4-ty@b4>
Date: Thu, 09 Jul 2026 11:44:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:worapat.kd2@gmail.com,m:axboe@kernel.dev,m:worapatkd2@gmail.com,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13924-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel.dk:from_mime,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DBED6733F54


On Thu, 09 Jul 2026 10:51:00 +0700, Woraphat Khiaodaeng wrote:
> The task-work refactor that moved io_req_local_work_add() out of
> io_uring.c into the new io_uring/tw.c dropped the whole-body guard(rcu)()
> that used to cover the function body.
> 
> For DEFER_TASKRUN rings the ring teardown still relies on that RCU read
> section pairing with its grace period:
> 
> [...]

Applied, thanks!

[1/1] io_uring: restore RCU read section in io_req_local_work_add()
      commit: 648790e0952789527ec68548edbedbc0fcff43b5

Best regards,
-- 
Jens Axboe




