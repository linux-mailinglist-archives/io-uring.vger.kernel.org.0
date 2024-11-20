Return-Path: <io-uring+bounces-4884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F34C19D43D6
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3FCD2834CE
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 22:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EA819D078;
	Wed, 20 Nov 2024 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="nxx2c3dq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8A913C3D3
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732140896; cv=none; b=MqUwLXuq9dlE57H5q8roPBgdLcf1c9kFq+yi7tEwoi7WHUrjX6Q9NvMTVQgB+YJBNNFY11k+GiHIpkLF9XooUj7zmK3j+qvWcfqjv7USF/cSwWMYVNDwHCN33ZxSHPseDhih08V7GZIQ3jgW5Fo3WY3/jQ489WW2KcA2nUxMcqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732140896; c=relaxed/simple;
	bh=yiQdMKXrUNCQLBoVsduPJrT39hxxCNRNPvqaUq5xRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lPZiHZ8Tsk6KDgPxCpgy3YWbOM6wHe5lYO3ikUP5A2trxFNNLokW5fZjsEU/wSj3tjR8KjoL8RyVL2/jasGNt6ptSwt4Rkh33GMV2tCVlh6bb0eC5IWDZHbotX795G8Qyzw2nLgpmA9SNMlA8sfCKD0jPGD4HVYnPmbXbcTcjUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=nxx2c3dq; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea8c4ce232so306185a12.0
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 14:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1732140894; x=1732745694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gTT2EwTl4Zc8GmHImqk6R/mxtFeX1RyQwHV+zzXarEs=;
        b=nxx2c3dq1KKvnftigavRcx0+tlhlP4V4qnePjKaZaQeaUbTKDW48ALfLpna6Xb4c21
         zdxEWXhQuvqPvVXqAGLa6pKjnZouIJoS2R8tcWgz+sWnE8Rb8AJK1k//BlKdHgalo9hK
         tIQ5Slr0AWhxfWEVhVXpo0FQOV0dhoElvmaKEMwzkGX9olyPpavt9yHg2lxiHon0H4BR
         cSzxLu7OwvvDdlQB3JAULrRy89n9UnPFCGvS+8B7MGCRhX9wXmA+rgJwqnK6H+OOwjkI
         PeZF1XT48fcV+lGTgJa5YF70Ply7n8yoK+2WKK3InFrDlXoBf+P70PAn441HPJzZf9j1
         X0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732140894; x=1732745694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTT2EwTl4Zc8GmHImqk6R/mxtFeX1RyQwHV+zzXarEs=;
        b=nf0tGGcaEfSBu8LrhpjOjucPvZ2vifTwg8IhapviT7hNhUpsT8S87EUFxDjivEeXpX
         fGxZM6PhN7RaNCyW72J8jJKWUyVLhDtVa1MlAYXfyDiTx82KyDwczpP26+Gp8dvq8TsJ
         71Hj8IIwvVDf7frAj1RMBzV2dyw8RX2CbxKlHEBHRWuLQ48JpBr6qwVWEN24AMN9R9dB
         ZVxSIV2QWnRTZ9k5Fk8bxAX9iPu6bqmhcU0zyHXb5LnBPgb254j/YyShgKHf/kkfnHB6
         05jws6XKh8lR5uZbTJC6e7NvB940QgI9GacP1/0goiNbV6Yu+z5l0n/qhu8lRI6k7/HB
         cI7A==
X-Gm-Message-State: AOJu0Yy2NTYAQdZQQtYnKEkEVXYDZef9extei7uuR+5M7AGZ+ufSlNNz
	Yzf8GQFY9DiQ4F/TKiTmBtPlmrcyZza2a3SIKQTKi41s5abSO8ourtn0My8DkNVc6HXwOq5I0da
	6
X-Gm-Gg: ASbGncu1Gp27L+o9V/LLdw188d5bxoWvEdppop3rlR11ngnZU0TnM7KFsan7QvNzkSV
	OVh7LUc2/wPs33khaP83Gt3iEg9+oBny5lEc64Ma6gkGfbueN+l/S9h4Vl6ebay+fOLNebSGMwB
	2aRdxzrCwItMhbr/U6NKPSCe4gytr91c/0kc1WeQXuVEtP34QwWJXoWdtTtN1qkVWSP+gXboE8J
	/roUeqIbmYyEn+Fc8z5NLssit5vGTTT9LTN3iIbnCOvQWGivuqooWeij3llCsVUGqUf5wwl
X-Google-Smtp-Source: AGHT+IGIImdwRP9igpfBocD7/oFbzJVbYRGHskEa+K9glftYOdUc1Dz9bnO5WlNM00QldS45ZIgAHQ==
X-Received: by 2002:a05:6a20:8410:b0:1db:eb5b:be50 with SMTP id adf61e73a8af0-1ddae1043a2mr6632156637.4.1732140894509;
        Wed, 20 Nov 2024 14:14:54 -0800 (PST)
Received: from localhost (fwdproxy-prn-017.fbsv.net. [2a03:2880:ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbb64e0f7bsm51801a12.8.2024.11.20.14.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 14:14:54 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH next v1 0/2] limit local tw done
Date: Wed, 20 Nov 2024 14:14:50 -0800
Message-ID: <20241120221452.3762588-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently when running local tw it will eagerly try and complete all
available work. When there is a burst of work coming in, the list of
work in work_llist may be much larger than the requested batch count
wait_nr. Doing all of the work eagerly may cause latency issues for some
applications that do not want to spend so much time in the kernel.

Limit the amount of local tw done to the max of 20 (a heuristic) or
wait_nr. This then does not require any userspace changes.

Many applications will submit and wait with wait_nr = 1 to mean "wait
for _at least_ 1 completion, but do more work if available". This used
to mean "all work" but now that is capped to 20 requests. If users want
more work batching, then they can set wait_nr to > 20.

David Wei (2):
  io_uring: add io_local_work_pending()
  io_uring: limit local tw done

 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 57 +++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  9 ++++--
 3 files changed, 47 insertions(+), 20 deletions(-)

-- 
2.43.5


