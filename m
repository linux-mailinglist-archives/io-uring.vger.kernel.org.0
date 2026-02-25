Return-Path: <io-uring+bounces-12424-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EP1vLbY+n2lPZgQAu9opvQ
	(envelope-from <io-uring+bounces-12424-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 19:25:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C537119C3B6
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 19:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CC3233013706
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40612E92A2;
	Wed, 25 Feb 2026 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wW89sYcD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F51E277026
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772043941; cv=none; b=rKQr0lqKXPE5CvIw55p+cnBasLjFBb/7K9qRQBmhgCXy9rcHfo7RNeyfCCrvq4LMh6IyQ5Ktb2kcVITKWe6xX8855MsRuyHUvDNJUinE9o5nOD+2WIyqiICZkxTS+xfoZQsURGlxuWRzzXBqosfyEpFaLeJ1BdTtxAR/OlY7K2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772043941; c=relaxed/simple;
	bh=XKkcjOmWcf4EpizLaZfROGm0TZ5bCIOU9VdMNqaV/aw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cqcq5Hgyq+bn8MzQvjf+CA0DGMyIBrmpkiiR9VsmdTUWPeiqdwB0Y1h7T4AXrUjHMYvwVWGUqmWy3+zfctNJCAe4Oo+qJZM4ErhGuFzRAlzKgXsQar+5N1uiEYifJonxxEWJIhMC1tYs/gwXKfIfafROWbmFDphGxlWLSkOy6H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wW89sYcD; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cb4097794dso699989485a.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772043938; x=1772648738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QSbF5DG2uvwPUVL7NWPjKmjZNO13dbrUz92lznb9LVY=;
        b=wW89sYcDrgz843csJvMNNWdljOCBZejTYe/R9osPcZOmcx/e9jF5aX/fm5xF0Vk76j
         Vra5IOzxui/uO2yxt2tIzTZiEwpj4ZEzJDIoRbemsrDru/kgNH5mMRv7zUyfdYB12O77
         Wh/SE3v5kqgIIU49ixeq529zoBUBV58KxRC3Mn1AjZzE0xbBVCIFuOKQGZi2acD55MQY
         OGcwCUVlZxaKVryxSXmJWiN6wgOgKoivBNcBKoMek69TUL+rfwEPDA0oZPi5+Qu44f/b
         985SBSo++yVzZeI8An3FrA+OMk+jx7kVAcycks8w8zmpRFpebjhi+LExXh9q/wXIp3G9
         423Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772043938; x=1772648738;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QSbF5DG2uvwPUVL7NWPjKmjZNO13dbrUz92lznb9LVY=;
        b=CuUVnWARk/yG+mvqUPfkAlISHhNngvccdNUjAPbRb1zTCU1uybrV3whkBShdeGy9DG
         KxuRneQwYIl0ifaC7fnuT447ux3KEXj+kQURcbW7vReIaFXJTnCyPfE+UyK8goClKjDO
         vjH/+H3UafbetjTjNknVzCYGuzs2M8FbCgsJI2O8R33q1aAjaFm3wVZlVaq3V5tYyIN1
         LOv1oXir0cIJ2wYks1t+A9COZUQds0LX07r5p86cE11rOyuVbjW8i+pWSeJWEvWYSGZ/
         KGudIzNS9463yYlyG3GoNUIXDH30jlBALCT86iYCKZMNXqrg92pJbQPBdLpVw2iUAruc
         dAzw==
X-Gm-Message-State: AOJu0YzXkNRSxZhn0sbPS7+Z6HZIzNT0+W1l2rmLvAh6ZJ9SEKAUQoRQ
	ML6zmWQNSGw2Vqs6uyZAWndIq5sHgEdULdAEL2+VZMXK5/tqOGcaMHGl83jdOLHrmVKYSMQdL1J
	ZJ5VWn6A=
X-Gm-Gg: ATEYQzwDdAbmQqJDU62kMpR0Wfps8aLWir2SUj9yNwqwpPS8Ozwyoy1UXpr5SsgjLpp
	F8dxjGUCzfIClEnQWm8AJDWhZS1QXaKWg9UWDI6qHkjUjNVfVIoZ8oD5QPbMPZCDd5I3edQoZhF
	215qT0PzjJHz8yu4bEQ49ed7JgvzQ0sOnzD/LFA2wzTp6mUaraNKAC9Kk4fMYq0clJI0GPC4bB8
	+nKMtd7dZXjKYLOI2yPxsWnA/j2iuR3qN6n0snD2pfjvgmveyQWbrSZsJ89V0pIL+R0+zI5yS18
	KFs4tsFI8hjsnbfq6BVVNz3R4db5qHAR5zaHHyVCPBeRkWGkOunplMjSxWfYsWKrlPZRR60W0Xu
	/W26CeV+a9GIGmvlSnnQztXNkbQQY9dOUQrnjzi9ia6zNKIBkiJfSDLmlVqklEkIg4fsULoITk2
	HSkHlPhnkfddG6ozm8JjTJ7dxLZ6LJDejZfbJ4X1hpe2S5En5/xDVLMiQEPpoEXCQD35t0j4Dzp
	Sc=
X-Received: by 2002:a05:620a:bc2:b0:8ca:90de:43f7 with SMTP id af79cd13be357-8cb8ca92d55mr2097238485a.74.1772043938379;
        Wed, 25 Feb 2026 10:25:38 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0461dbsm1529427185a.3.2026.02.25.10.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 10:25:37 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
Message-Id: <177204393750.859526.10343447570329209516.b4-ty@kernel.dk>
Date: Wed, 25 Feb 2026 11:25:37 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12424-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: C537119C3B6
X-Rspamd-Action: no action


On Wed, 25 Feb 2026 17:28:03 +0000, Pavel Begunkov wrote:
> IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
> SQE without indirection to a user timespec. Update io_uring.h and extend
> tests to cover the feature.
> 
> 

Applied, thanks!

[1/1] tests: test timeout with immediate arguments
      commit: ac9b8d0daedc2d311a4a43c88689fe7731657cec

Best regards,
-- 
Jens Axboe




