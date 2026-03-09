Return-Path: <io-uring+bounces-12595-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEjhMh/frmm/JQIAu9opvQ
	(envelope-from <io-uring+bounces-12595-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:54:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDBE23AFCD
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8775F305F670
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 14:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3F83CC9F6;
	Mon,  9 Mar 2026 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S1LaLvBd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4678C3D34A1
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 14:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067966; cv=none; b=OfQvyEhXFi6SN1N0dCJnPsrOBVS+UjvI3VXbZ+f+4D7qh8AuG/RoFqyyxHqr497bSPnxXW1xAnBpYLGs//opHBctr9YPZOZu8+rDpf+STPr1lp8iXJwF6zedZC7DLu7DviHEdMaM1OiYkTYWFYp2J0vH2zs2amSjb/DniNEpiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067966; c=relaxed/simple;
	bh=aPy/6hhN/V5a7uc/27wXwrBWThslXF1q406dkQTxKxo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VXRjLU+AwijGiKmk0p355AbAQ4t2nKQyWNafXYa0BZwjPZhpcoCwZ3w60HAEIj2wyDO9GmJhC3dcbiYihBd4gejgXycwBDndgnNX2+5fLuRYAdUhzWmWmR/m+gpd5WXi16Ba4kTer77k19N5eLqj8jLGEgNjCGu1y/v+hSPm30o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S1LaLvBd; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-509164dce91so11976741cf.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 07:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773067964; x=1773672764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIJMXbO4+IBnoz+CKcpqEgZVGfVItmQJcbLRuaiA1Dc=;
        b=S1LaLvBdn1idxtENdW3z8SAf3QdBiKYPR1Mi3nXEkOkCYOOpesgW+HLCzko/Tjj4uI
         mWJ4EVmW40oNbLDk3FZ0OWNCP9lham4K8NsSEW3dY10+uWuL/LDAgSBxuJD1VVejCWGo
         chITbS6WWEP9BbbjVnk8NHK9qdL2ekfp/dyceccUpltpyMys0aOlQfUZXMa1MU8e4hYL
         yW4Um8QmyZlnHdIob3r5UBBH/9lbVh5sVuaVRo408G8Yoe0fYAitvAcCOUgON2DRQXDx
         40NcI7jMldKonsiiJ38EtBGSG3qOX66cXRTLxcYO18IBZiaQMWurJj8vu/nM6HegLqLX
         6dHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067964; x=1773672764;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tIJMXbO4+IBnoz+CKcpqEgZVGfVItmQJcbLRuaiA1Dc=;
        b=naxxKA5aY8lU95NIpTSykxAAcLylEciW3Q1Wsc0/s1BJr+o8zEpm8K3uwZ5SxcFD/G
         aC3slOJXIPZZhK0VKY7vh2S6M3l2kh7EuHG3q45Zs+701MCwKV8PbOohXnfFYLBRinj+
         TCp5wm8pZ0dG0O4Mjg4Q6E63Zxb9JKKWgvInvI+Hu8n7YnH6ZZA2eZRdwgRB+m3a94TT
         o0Fc5W1pj54X7haA8KQFEhaOENKB1uaw4k5P0p2oJjdKyY5bMAeHosapDM+MNatCHLPC
         R2cUP/DmixY+MVN8VVIYJFoBorTcSZI8vri+hA1AsDElEAQGX01/RMABlt/iIZFfOmmM
         7r9A==
X-Gm-Message-State: AOJu0YyDj9BBUqaoMc4pUQXt1DiYuMYogZux2i9EsyX/gi2nPgLaZ4UU
	36m5coapcsbWw5+8ldI3Ywm/n4+FUKa1M8n19pFFsvaZs4j6t3JNFKmTfgW6/zfZvy+LaMjh7zw
	HqBDXAG0=
X-Gm-Gg: ATEYQzz0dC0FN36B/HBWnZruDr0dBpNOGOTHyVqg+BgFfw4JBYpyIPZUHjmKdc2z5nt
	173wAMmKESVfQUE0IxHaZJiHgJdOd4JUeFfKLwu6RkCMgWtxHl5x4kjHxeO7Pa7nfvS1AbjMjVj
	5eeqH+rt71FiAOQLs0G+hf3P8K5fnMVfuOvtM9yviXPozn5FMJiMOcKj2VnjHQhUVUQkcbOvFZs
	wf/EnYVj5wO6jTslRfbv1stPNKgFP+MDV6FJKQaVkKAxO4Us7WHmTG0w8op3EVrAg3DtJaI0pYu
	sJ+Lzv37C9cWnDf2riKXn9yBd0AQCc43hTG706iPBVeeLGcTjHxin/ZQdcoKTIa3ALAEBHKIEiC
	xfDvvgU4r+V3VeiwoKR73OQXwRllOfeAc9wwn1zjMoQisIuhvmhWGvSljpJw7cXh5Ro7QHDHiqp
	eH3XrA/I5oRstz6G59RPZ/1Javbsmy6HrYpMfvPRc9cQP+k6s=
X-Received: by 2002:a05:622a:1920:b0:4ed:6831:56bf with SMTP id d75a77b69052e-508f46d14c2mr155327781cf.13.1773067963875;
        Mon, 09 Mar 2026 07:52:43 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508f651440dsm65793431cf.5.2026.03.09.07.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:52:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260309-uring-nnp-comment-fix-v1-1-e7d185527142@google.com>
References: <20260309-uring-nnp-comment-fix-v1-1-e7d185527142@google.com>
Subject: Re: [PATCH] io_uring/register: fix comment about task_no_new_privs
Message-Id: <177306795829.32482.2304203506937984154.b4-ty@kernel.dk>
Date: Mon, 09 Mar 2026 08:52:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 6FDBE23AFCD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12595-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action


On Mon, 09 Mar 2026 15:34:41 +0100, Jann Horn wrote:
> The actual code is right, but the comment is the wrong way around.
> 
> 

Applied, thanks!

[1/1] io_uring/register: fix comment about task_no_new_privs
      commit: 3306a589e598b50a5bbdfe837371670b507043c0

Best regards,
-- 
Jens Axboe




