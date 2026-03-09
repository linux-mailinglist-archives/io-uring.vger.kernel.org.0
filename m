Return-Path: <io-uring+bounces-12590-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iCFzJPvKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12590-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B04F239BC6
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 122CB3053760
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499BB3A7F6C;
	Mon,  9 Mar 2026 13:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GiWlgy9X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44DC35A38F
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062704; cv=none; b=qmLmeYlH2owfsGfwqm5yj5NiEUj6IIB40IGXypHcTyJDhM3c742Ppqf7niX2NloUOP+CvPsTKFJjD5c4ztCt3xkEh9aiw1l4iiK7/8JZrRHCv/QQKLrkBxUQxinvy6vaXU9D46cgHY+3i0hgZMvUClHHel2FgzUTv2qtvYDCdb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062704; c=relaxed/simple;
	bh=u1UBFS4M5MnRVDd1ZBe511eXkq6aXxNZYjpqFYC1wm0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h9Ha+J6+KV8O0LYt76ll75+2JFaYPLYMo2SQ1GOopg75bt5mzwt59j7SkzYJ+s+b75viIKWsWnVTqMd34S6c1QMisG1+d3NnrRSleC5QcDpl3KE/PNJHpfxMW+HmapW37/sUgQOvfrkfHAJL7GmM8fAGja1uihF/8/kB5Yl9YEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GiWlgy9X; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c9f6b78ca4so1520755685a.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773062702; x=1773667502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd/9SXYCgkjhEN5+Eb60tHwUdfBhtp5I/Y7iSzn3AlQ=;
        b=GiWlgy9XyTtkuTcwtVwT00XaYQPxMXsrJh7QcbbpuTMbywxtCOMiFJkzK6EOyJXP1L
         Vt+dy9UfHz24qHnFPniahPdlT3p4R1hevB+idjiaQ/Idar2DlpLnyeQuv641xa+8Tw0f
         iYJvNBOdHizHSZ3HumbgnAPJEHfs2XLmtTzqOc4hrxptRFVe0iQulXahasdpd/ydGmgY
         XJTjwuVtrfO7kqAFUEh/8DPlM4HckVkUB37bj87EcL/3HzLIGyjQw7LNOR7b2qY2zl/4
         Ceg4F1XvUTWPcHqQHwV7Ew8ifqx17vsdkLAfGvRwSRLVf2RfXLzNWeNe8FhILg8EfLGO
         7R7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062702; x=1773667502;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wd/9SXYCgkjhEN5+Eb60tHwUdfBhtp5I/Y7iSzn3AlQ=;
        b=eXo3lhWL6DO18lD5d0M49TZkyit6OIFW8vkFkZO3nqakI50xzi6Pb7VmX/wUmsmIbG
         mdpI4EO557MhRkBmmmEHXcnEG3pxjlzTXrIN3y6z6lhKjVP/bRLLljFcrcWcE/IAZdcq
         fThp+7MOPRcP2CCCZkkyU9kj++8F3OkhFWlfm47akjds3kKvKPNI2Oqd0nI3/XR/UJp1
         OzQl/VRqyGfypkIF2hT5fFG65RmNfzAs0TkbK/1/x6ZSSYrldJ75t9eiei30fj9N7Dw/
         nDO/o4/i28/v26cGNaWHB6j/Z87l/C5CM912s+0k/ZPxEYNZ5U0LnQUPLujzU3jMYUo8
         9bqQ==
X-Gm-Message-State: AOJu0Yzi/uUqupJPpBYGDLPJh4OPefL17NHbJqDrcmDxvWTYnOaW15a1
	8hDa1Mp93+RbTsdSoMJj1yFDf76U6pTJOTE0ZweqSGPIwk7W9zAeMdtJP5vWGW22oEc=
X-Gm-Gg: ATEYQzzAEIpok4sJO+81qHpfmSGrpXtQhhKpCuJmeSnOIa4l0IH0sREO655RDuzkv25
	C9Qi1qLHJOECqD1cWXAIhffe94YHb6YJ3cymFPxBoywhnvNBg+kwuNUqTla8FuWnmak6CdOVUDa
	IlvmXkUg0E3kLISa2+FsgOoIDBSz8T4psMquUWpAORVnNxk6Ivs/hN3kk5zuH/wv6qxITlKbBuq
	33CI5jEFdmWE2GJR/11BWvr7s5r6ULWKa1tSaCUXuZhUxy9w88uEORy34HWmTMvTuw2fI1rF4AY
	f1pFlV6Poyl+uzhTC8/Io2g0pxZIQaLdihBObqOYfQyUIqYFwx+gb1TYEQAbcZp3S9pFEsO6B4F
	+2G8oTuwZp9ojR37d36RfwMb1iWYnTLl8WeRyXLc6GoNtbl6xW53ZbRV6n3Blx/GB5i9mRp/f2Q
	sW3+ZKeiJRJTnNHsqLsLOhFjEFpiTOgnknWfNpZfNDG/N/dQI=
X-Received: by 2002:a05:620a:290a:b0:8cd:8f18:d1f4 with SMTP id af79cd13be357-8cd8f18d614mr165674185a.6.1773062701353;
        Mon, 09 Mar 2026 06:25:01 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f4840b1sm680245985a.1.2026.03.09.06.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 06:25:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Dylan Yudaken <dyudaken@gmail.com>
In-Reply-To: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
Message-Id: <177306269693.10980.16599350197226098615.b4-ty@kernel.dk>
Date: Mon, 09 Mar 2026 07:24:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 2B04F239BC6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12590-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FREEMAIL_CC(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 11:48:52 +0000, Pavel Begunkov wrote:
> People previously asked for the notification CQE to have a different
> user_data value from the main request completion. It's useful to
> separate buffer and request handling logic and avoid separately
> refcounting the request.
> 
> Let the user pass the notification user_data in sqe->addr3. If zero,
> it'll inherit sqe->user_data as before. It doesn't change the rules for
> when the user can expect a notification CQE, and it should still check
> the IORING_CQE_F_MORE flag.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zctx: separate notification user_data
      commit: cb9487333652b2cfb4f10ef596fc5b675241cae9

Best regards,
-- 
Jens Axboe




