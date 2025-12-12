Return-Path: <io-uring+bounces-11028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBD3CB9A50
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 20:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1990302BD0D
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 19:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29F252EFDA2;
	Fri, 12 Dec 2025 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c5m+1blG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563371F130B
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765568278; cv=none; b=tYUWHN2sjSbiX/TArX/wGfnoojgsIGyuyI6noJ2tYnr8+YXrMqcuENekaRDtX100le/BNEvDEFzGX2OCBysmq4K0OwqOAtH3Dv6sWLoLT7FdXYn+m4uVikFNnVmETcTiw8vAvqQSmov2weYQTc59eQ5QcYF+CMv0gLv3vAUcwd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765568278; c=relaxed/simple;
	bh=VwPoKas3ILAATq/SFSU9txmC5xK1gqUaBfTmIdhRerY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iGeYa/vZibFIL9b5Fjyd5RrzXqiKM5Ux/tYpHPs8F1pSgYm06oEUsXfnbm0QY//lIXTPa99c/F1I2REZsD5RqK3IXMgdyUfFL0NPxjXYujycxsg+DY4A+Gsums90g1jMKwIoWlTEjmnmci+8jpUj0S29SohKWPnIcX5WovHAvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c5m+1blG; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7baf61be569so1961511b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 11:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765568276; x=1766173076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StTVbGf1mPsXgZZ3d28QJjsQQzKmymRGuXpSNQalBC0=;
        b=c5m+1blG6ge3DTAI7nAHPhHVgc+BMSIozQa31FSf7ThS3uIGzs6iGbu5PHP5lZK4mk
         /W08Ke2mOJQH4C40BdtfgEliG2aCkSUIchXVjP4aGDgkbo0NGKKk4v/sT/pqKhRGdy5o
         LuZC4srxaPdLlCTyoaenvnA84F1454vR+yjfwWRRy3YKL10qgQesEYH9Rnv6iqwsVcxc
         I5OR++zJ5pQK/GATzEEFb7QZSCaV9k210EYF57fpDIjshNzaQd1INI+hKc5YULhSkk8s
         xRrNg//TV/wQ54QZ3F2hmQGV1pIb1fLNpoxJaPgjkMFuahd/64ye/4BaIkJPat3bdR6V
         Onbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765568276; x=1766173076;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=StTVbGf1mPsXgZZ3d28QJjsQQzKmymRGuXpSNQalBC0=;
        b=TZIu0+TtR4gjfzwdMzHEvhPOzjcvco48AoO9KgnjWp4+pQuJqo+egHKJPlAdbTNRXf
         +mxc4r4hFlKJQO5R7ggaZmVtPtNUTMweV3mk6bFov5nWMk/BqqD2p59QqHwsQaNqY47G
         YEdUNynPPcmELcGQHvC4+dJQZrvGEgiyyNUngGTHgUiipeJjlj1i8JANTN0fKTsbRUC4
         gWJK2fyNr8YAiNmINnQJ/UiZQwLJp94OI6yQPKjFrlw/+9a2Z0IkrIHxUuTj0c2A6i9N
         aIUJO7J92fJudZurkIe9IAmn+6ijzrtImoYYS4sVOelv3g5rEsZZuVEqDTjBDIOJiSLp
         0C8g==
X-Forwarded-Encrypted: i=1; AJvYcCV8SM+w0QQXuMbFJar689D7nml0qbk8YhJiEvwPAOf/q9ZUoHcsycUGXAKbmnQxDakxtF20BRIi4A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+hrrDcHJlSvBsJCQEbJSrgHjV6U3hbDRaaHHlqV8vzKgyP9zX
	fGM1o8wiTWq3F1sOFkIglOcMX7Jayfk5cs7BIxxPkM2shg9fCzD0Qf0xfaXmLhlWJrc=
X-Gm-Gg: AY/fxX67xX7GEgnzQA1EKYaE6utR0iv6urnUVWbHZ/de+w+gIX7D871PS/b6hKKVrA/
	RcUGEpY1OnEy3WPU7m2soDAoMNRBebla3YFygLXGEcsLMqHxKG0SajvWundeFzj5vbEP+oS/MYr
	d544M5H6OtCOeJ2db0EE0Mx4z8ux6fEo/UT4IhrkLmh2kejM6Z+k6bs0cWVUBVo2sizILRStT8/
	ebvfJqV1huo/EgxCFPh4q2V5OIRNql+LPEktnwqvEUR47eb2fb0gmbFcLFVVH8mttbrPfIept3q
	lqAPfeeyvkted36NEcArrqf300jcHqw7r7rymYJqg4HkljB/448467TkV1roHCiwgEcz3F1JNBG
	q/LmDmFjT2lHat8IgRaIHkzqwrCeil6sFarWKJ8/7uAOMjk8/jefWO5vqsezb+eANptaDmlM7nQ
	kvlPzrHaxcks+vFFjLmVgZXodQ+8uUP6gxY2yBRzRaTOgouJe0GsmPD95P
X-Google-Smtp-Source: AGHT+IGRg2Nd8ny+lEY1UTB7dhC5oApF/NmRzRo0kswvAor/xhBJns1Qxh+lICHO2/Y0nRHD/a4u7Q==
X-Received: by 2002:a05:7022:e1c:b0:11e:354:32cb with SMTP id a92af1059eb24-11f34c39abemr3023356c88.49.1765568275584;
        Fri, 12 Dec 2025 11:37:55 -0800 (PST)
Received: from [127.0.0.1] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2b4867sm20294552c88.6.2025.12.12.11.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 11:37:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
References: <cover.1763725387.git.asml.silence@gmail.com>
Subject: Re: (subset) [RFC v2 00/11] Add dmabuf read/write via io_uring
Message-Id: <176556827123.851918.9976241171726294701.b4-ty@kernel.dk>
Date: Fri, 12 Dec 2025 12:37:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Sun, 23 Nov 2025 22:51:20 +0000, Pavel Begunkov wrote:
> Picking up the work on supporting dmabuf in the read/write path. There
> are two main changes. First, it doesn't pass a dma addresss directly by
> rather wraps it into an opaque structure, which is extended and
> understood by the target driver.
> 
> The second big change is support for dynamic attachments, which added a
> good part of complexity (see Patch 5). I kept the main machinery in nvme
> at first, but move_notify can ask to kill the dma mapping asynchronously,
> and any new IO would need to wait during submission, thus it was moved
> to blk-mq. That also introduced an extra callback layer b/w driver and
> blk-mq.
> 
> [...]

Applied, thanks!

[03/11] block: move around bio flagging helpers
        commit: d9f514d3e6ee48c34d70d637479b4c9384832d4f

Best regards,
-- 
Jens Axboe




