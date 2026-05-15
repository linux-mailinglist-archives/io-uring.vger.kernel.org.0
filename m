Return-Path: <io-uring+bounces-13348-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFy7DrAdB2rnrgIAu9opvQ
	(envelope-from <io-uring+bounces-13348-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6455505D4
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 54959302473C
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49838317150;
	Fri, 15 May 2026 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="FHph6bJg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650AF2BEC2B
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778850808; cv=none; b=GwGhwtnyBruFTios+7yaDDDfPyFno9hvgS7paZQawBQ3Zo25m6Wh4ONeHzsq6gov9YWeAWoakCoRZ7Al+37i9JF7WqD7bkG0sfQ2i4zuIyF3BkAwfI3NBxUoH0J2C2AIXP4LcvwUAlKimL8c8fZ6hplH+qINs9IuN5WSBmcbiyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778850808; c=relaxed/simple;
	bh=cLeuyRzq2UZx1BbP82I4hNbI/QFEseygzo9t0FA8NNw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Zt85MbORwlCbkyoDKa0yaR8n/WRfWQoMKNq3GJPIHWQsr/iWjrjqH3g5ReA6TVtQ95F03WGPbu+fActLXvduDSVe5APLzS7Xbve/ftYEnf7c+m02shd9OWDbC9zdjthTScZ/2gaKlEOW57Ks695pqz9jiYQMd0I0CNZwuXGdvQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=FHph6bJg; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-415b23dd6e5so3449954fac.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778850805; x=1779455605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDKz1lmrdRKtAmXdmSgBSoL59WO2xi/t6uVKo9Oblco=;
        b=FHph6bJgHzKmBso4G1/GSSHoBqXTbRpHrTcUQtula0SoMr9vWprXSIU0LlV8ULc8w/
         ECgzUSr/psBxoqlEGdkUttS0VoEwAUIpj44NpkXverDe+98mA1LuuAsVicW1EFWYQpuf
         JNawq196LKBky47ytFmhhA1VUO6Xwm853fH9hd2sEZYF4FpmcbeJxIW5+kXvQoYV/UQO
         l2pCyjz5XrXaJ1eL1dwNIQBCqAyH+fMuiS5p5hBW67r1U+7+QQ+Dh2LLmBHplsj1eFRH
         asmxqEFonPE9FjQSUsoE92WFuHn88leblznUPRfbocw7F7/fRzKETJCEENuO4t0AqUJS
         EGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778850805; x=1779455605;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VDKz1lmrdRKtAmXdmSgBSoL59WO2xi/t6uVKo9Oblco=;
        b=BWBOR+G2QStu46z2Y1oSlGBijREvqWpTNo1fHQ0Hq1PnI2MgMxmZHCG/U+rJQxfwny
         O+1SWtLZqDnqzBcbrHLY5YKu2xX2/vMn8O1EN+EPGpIarMYIkTS69UcbdgqZp3WQDOdu
         s8fahKiJGTsNBpmdPsqaMXtH+fzF19ONbbknxiyU08fwV7OnlOWf4g6ti9LAl3aXx+Kl
         Aw5hZliZ15kyfqIWPRCwLkbiL5+55K4pl7Br/IwRaLPwFtlBuAM8+zyQ0FVq0q05gdk8
         iRncyxMsubUJHQ9pYXeD+O2kd2SISc2vhKGM4Bjl+oPCL9uobJu2zoELel8WjrqjwQu+
         CZiw==
X-Gm-Message-State: AOJu0YwCyNRAV0iEChirpychIPrb1dOrsa23r2gJOvRwoq+KJNx8gcjE
	9ZWcAeUvnOjjybayb9zlTcTGrOQe7SAMrsNCqi1rHESqgC7tTiWIah/+ba7GqehfYcFQqtOXnPF
	MoIbp
X-Gm-Gg: Acq92OFDYkpMlTPRX3ld3iAuDyUCUQlo5JuZwSN5i7WgrBg8hE3Lq36oHWJPf5c8fYD
	G7xmFGh0pRM4PN+puWyj4m4KzGwjoALohC49XTqkzZ+NA40L0Eai8cPXzW1hnRbqmBRnLb4HAaK
	ZM+CAczFeFV88AiWN+SU7XNx8/4OB/GxDsibIYCV54CBMJwr9sIpIwbiW/RW8CFPbTMfMzPFr//
	23hDoVGXyqbrZ8YrXO6KcsJKF9NsYGcYpURFuVRVzmqgy+4V3IuguBJT0/NSigY26TM2epfwF9h
	KQod+131xIg0wJdLJfwP7aNuJSn4W4173oMx4uMwuqfC4w1od+6ciFpwfNNnyM+n9hc0BQAbaOn
	SvX/j69zjjg3qNXn96cTrlLgKwHl1mZg6JMGZ/cUsGo1w46vGpDrPyi8xVlBDxigqvkAE9Tzw6p
	PvoFaqfZs1G2HzfictJWCTZy54klwi61BZ36TK77lfsMofv5zAThCLr36KHjLROUEMTxxw18jWG
	KKz
X-Received: by 2002:a05:6870:6486:b0:43a:2c78:2ea8 with SMTP id 586e51a60fabf-43a2d90a6cemr2477018fac.8.1778850805237;
        Fri, 15 May 2026 06:13:25 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc4dcb89sm4160706fac.12.2026.05.15.06.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:13:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fe6674d9768120da6054f1ec1057ec3db3c45454.1778775953.git.asml.silence@gmail.com>
References: <fe6674d9768120da6054f1ec1057ec3db3c45454.1778775953.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: test abnormal zcrx removal
Message-Id: <177885080419.720964.10011030774553371413.b4-ty@b4>
Date: Fri, 15 May 2026 07:13:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: CD6455505D4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13348-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Thu, 14 May 2026 17:26:58 +0100, Pavel Begunkov wrote:
> Add some tests for dropping zcrx while there are zcrx recv requests in
> different states. It intends to check that zcrx is not leaked and killed
> in the right way.

Applied, thanks!

[1/1] tests: test abnormal zcrx removal
      commit: 65ead1fe5f22e42c6585884745bbc99bcaf82a92

Best regards,
-- 
Jens Axboe




