Return-Path: <io-uring+bounces-3824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 039CE9A45FF
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B899A28365C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCAD20E312;
	Fri, 18 Oct 2024 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WqmJAbhY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533322040A8
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276673; cv=none; b=TLxkojwkpNFv/+McVAs3iNm7FJ02jfTsrMz2+HW3zQ3LYJxn/ne8GTUUUVPRkM46lJhS260pj5Qyol8EUmQfVDlODTZvYwWQFC1jvCG7HQWFCB+SYhDkDJnY+VkCESUezI9wuqOzXP17b7SJ0cEgOsEYZYNlfeHS8jctFtH46BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276673; c=relaxed/simple;
	bh=4sFNLOPwv0VKTOk04bz84fudm20jTgSTC5vg73pKYQM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hK6vbMEG4OBjWlDGytVvUTTV+7X5u4bacRLKlp8TyiHA1E+ZPxgnaI8ARDFQZPp8+4et76P+436f6F9NjKYwDO4GLGkuLU7G/mbYGfKOGbLbobH5SfKY5POrL2jum8NhVU7ibHh1UUZ4z4ODzPqXN4ZNB7E3pVS68WvfTMzr4q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WqmJAbhY; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83493f2dda4so115820939f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276670; x=1729881470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OX3wNk2hPIDI6reEBeNk2qg+bcv+hLD931zVmXvJmtk=;
        b=WqmJAbhYm98SdoI25pGopKeQM/MfztElhzMLVBV4wD+FK8LgKUpbex9NIJ5b8bpcGi
         9/wiImxPKsPpl+ns4B0Pr2Hk/29dSiyr3qliWynBbVejiUbj5jaqtdhfs8gbfCByEZD1
         9KRY0eGCRsbevpVSMaAEG0/bOq6+i8hS00Rw4YVFwJ6ru4tuJrtA5Hs6+vp3QkSkhLEj
         Pyx9J9BkK1SEr34TIUCBrSEBvO1wT64oS1XCHGAjdy4oiMhH3E3P1JPxbBA2Y7TunRvt
         CK1DDQscaIG4ElpFsZQBEkwSGBGI5OmYuE1N05hGgktWLi9DG1CNX7G6a6KKh/roUdbJ
         XCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276670; x=1729881470;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OX3wNk2hPIDI6reEBeNk2qg+bcv+hLD931zVmXvJmtk=;
        b=PdRhTLRB3Wr6/PW6RVDfuY+onZsCaeaOKdGHgkAeoVarPgU0BzMq1h0pZ5KAzz+y0+
         w7I6XwQNsrN0QDIViAIWzYkLGeXg8WREmeoUQxvdMGEuR6zfne6wp5/5HSk8cb8OXvVG
         rCTK9u3oL4HNiuRt+V2BTYzfBkkvICt3Lzoc4bu0vJbI9DRi8a+KMOMpLQQnxkmJ1M5R
         TxqAoVWaE0UhefYhHt30HqNdV/gVSsRY/m4FYqrtKFozf/uvxrKv8m6MSRuPzhOeKIfJ
         M5RAERzPXt25Fwl8jdOkvWY49hj718xC0k/cyK7ub0JoBrGP3ktzVHtT3YPoMuPYsuLf
         vyqQ==
X-Gm-Message-State: AOJu0YyD3pDN3EneTNwGZ3gragBk4co0mHNkXCsPE8zqElGvozlCzlDN
	ZeTnqPAlJdI7i+KTwM4QhkTTJBXA0bmZuCw4KaM7UheJpC+EdRuQS7sjfxmoeAKPC+PyCZ7DAfv
	X
X-Google-Smtp-Source: AGHT+IG2NWyrH7Omlx5MeF8+yAReTbmKifnlQEu2JYQhR4I9TUmm9YdttRGSr1M60fxpyI1/gts9mA==
X-Received: by 2002:a05:6e02:3b09:b0:39f:325f:78e6 with SMTP id e9e14a558f8ab-3a3f4125edbmr23109565ab.0.1729276670395;
        Fri, 18 Oct 2024 11:37:50 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3f3fd7ea6sm5366675ab.9.2024.10.18.11.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:37:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c164a48542fbb080115e2377ecf160c758562742.1729264988.git.asml.silence@gmail.com>
References: <c164a48542fbb080115e2377ecf160c758562742.1729264988.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: static_key for
 !IORING_SETUP_NO_SQARRAY
Message-Id: <172927666876.464574.7712211334740270761.b4-ty@kernel.dk>
Date: Fri, 18 Oct 2024 12:37:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 18 Oct 2024 17:07:59 +0100, Pavel Begunkov wrote:
> IORING_SETUP_NO_SQARRAY should be preferred and used by default by
> liburing, optimise flag checking in io_get_sqe() with a static key.
> 
> 

Applied, thanks!

[1/1] io_uring: static_key for !IORING_SETUP_NO_SQARRAY
      commit: 9812732ce65b9690720f772c07afadf38dd7d8ef

Best regards,
-- 
Jens Axboe




