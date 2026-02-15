Return-Path: <io-uring+bounces-12209-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oKkzDzUckWlRfQEAu9opvQ
	(envelope-from <io-uring+bounces-12209-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 02:07:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 943A213DDA2
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 02:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E2EB301AA5E
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 01:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEC41A23A4;
	Sun, 15 Feb 2026 01:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FLvavGkK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2EF16132A
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 01:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771117599; cv=none; b=YZ71UpYk97iT9tbSWY5GTHwZ0T1ajAQ3fjDh5FUmfoFDDPVkB5iqkM2s65mhff4NSACIXqFPNr9ZImO3iiPB1+0QetGvbdIHlzyM8DkwoOagT9/edJYO23GYqY1ZSmTfVOtGOVgQalNKmz9UtnoC7HvpoZ/S42LdMt+Hy1oTE/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771117599; c=relaxed/simple;
	bh=zBOFt6D2OmOFM8AUA/bjMmFQFOO0ySymD/6dbPkFFb0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WCYhyA9RpRxOjh1O3CDsz5brhJhkgjmkuYkK+46gQZ7H6SmkIHnXsdZHvrq9i/QvkrYsZZbs2J/vbTaL9dLoiPYAaqU23Rwc1O7VMggmGYwnGwFwXrcy7NOKVPcqDaVpsbDHYycE928M8SPbOf0N7c/6lTMUT7oQbhEro6lruI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FLvavGkK; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-46391e91e16so1290715b6e.3
        for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 17:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771117597; x=1771722397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFPqG2MPH94wr47UdbEvgbtEhE7zbNXFowJ+m2ozxuI=;
        b=FLvavGkKV5YSxW4oJaCz+lc8eLzjM+SewTqBNHE1JHaf5VifDuxuJ3wY2wRBK54HqG
         ItDIDDX0M7D4EhttM9+/gD1dApFKK1uoCHvNr9HkSqWG8DxbWzl1+valWlurc4c90oRo
         z2PCq48At0g9eghYsqut7jYasAty12SnAOvY2viVmBHyereXanhtOsa4TbR/0H6sdczg
         2bOFKWh8fguUge5V5wpE0JlBbc/N8XtT9aeW8nPgp4TiY5lulmC507rdFF8a3Gw2o7yK
         rzolaF7qqGPm6e4UqSOP8SBCfPHqo+pH+WBACEajD8wlCRW3pTX6yz6XWlH59FkX2jFc
         Qi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771117597; x=1771722397;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BFPqG2MPH94wr47UdbEvgbtEhE7zbNXFowJ+m2ozxuI=;
        b=fEsYAsz+7T/osOqUPF+ilTyW0Sh9BkQQfHywKH9QurD9RL7jOEWEEtDqk75pT2bd98
         NFAaDeGPcbbI9hE5ddV0Feu1/KvrpdoQerdvsIRAqSv080p09v3eHFcI6IUhOmTEj3UR
         rrde4P9XLtIJrS01+80IBnxNtvjOUbaHfqZ59o8jrosdvUWZFegmFiHu7p2dqXEv+XZK
         oXG7dd/2BMVCfBbWorzXQQC4aj2tLDxQvCjEKDMzKG2+zVYH84+CD//pX/4sK2LeYNjb
         PkpjT0uHeEWPzwK6zK1hjaIAIVN/HksTgGbHeSQ4h1aM4KIvw145OrvA3Ie0vlgViUB4
         g3RQ==
X-Gm-Message-State: AOJu0YxvGEDpkVUHPNbcuEHiy31dn48agvYduiDtfnkZ2lsEwziBkSKk
	aDi4Kkvj/lNyiQ9Sjx9GHpWOFyJUNZZTNlZp1m5FpEF6iggnBdXcBHN6D/LcUmz6+EcyaxpqVsd
	jiC3BI2k=
X-Gm-Gg: AZuq6aIAb6lkJVMi/kG+oQuCBy9E+KbZ0dgdqwdpxmDcFTUb0PkxNGqKEWH+m/79W+i
	bcrK/YqBXLKWHjb1mOz3ENg73kYcoj0TDYpL5aEZwIytMKm3cZHOrTpz1ib/O9/M5E0dCkQbIpf
	bR/svG+J2OX65Wdrr710Pdeqf1bqdrFHPp5aPw2l0wYAJMzCvajokgjHJGYI980UvbNrk/Wpw1F
	USIuzjT/VjQAIiAGfcqmLOAZYDGR3KddTXStJVVcO8IbfMIgKxX5n5jExwlfi3qjzzCwh7/sAlS
	wr6GxylQkH4klsrLDxUHSkWkrKOiWR/M8gMH9ePCOLGlZE3Hh65sT/14xFFKN+UdFmjN9hR1jEz
	of14JbDIENSi8/4Z50PFQvtP+fyjk/42G1kUH2xOFn903tJW00fiL9O9YwopcdUToo8Gj9nAisG
	0rhXBaLWky+uEXKGPD34d1K8g67Ree2v5r/E/H5jpNnNlqel8eY9i8PsdkQE3Ycwm6M3nq6CLt4
	qAl
X-Received: by 2002:a05:6808:1b13:b0:455:d5d1:8ac0 with SMTP id 5614622812f47-4639f25d294mr3251767b6e.53.1771117596724;
        Sat, 14 Feb 2026 17:06:36 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf1e858bsm10583097fac.19.2026.02.14.17.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 17:06:35 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <9d9cdc9ae6c6d59154e68f65054d75893a749d14.1771091720.git.asml.silence@gmail.com>
References: <9d9cdc9ae6c6d59154e68f65054d75893a749d14.1771091720.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix post open error handling
Message-Id: <177111759535.436334.17052455952625566060.b4-ty@kernel.dk>
Date: Sat, 14 Feb 2026 18:06:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12209-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 943A213DDA2
X-Rspamd-Action: no action


On Sat, 14 Feb 2026 22:20:47 +0000, Pavel Begunkov wrote:
> Closing a queue doesn't guarantee that all associated page pools are
> terminated right away, let the refcounting do the work instead of
> releasing the zcrx ctx directly.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix post open error handling
      commit: 5d540e4508950c674d6feef1d95463d039bbf4f5

Best regards,
-- 
Jens Axboe




