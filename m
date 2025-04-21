Return-Path: <io-uring+bounces-7590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75126A94D10
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 09:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAD9416F9D0
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 07:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216511C6BE;
	Mon, 21 Apr 2025 07:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNqoYI5R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639621C5D7A
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220266; cv=none; b=MAQPEnv+2O1ODqTrhl+TFqVUDXMIhlIbZDOIZvzKvNwNb75MJeeCclvOGNvMn+zvI0Ki3Gm6xAq45Iqd4c508diG3SI/kowYHBptMIPZM9uswedIuRQakTLqdDSxRCgM3AqdtMMuCxLZC1MjjcdJl4GekLnOvg9TjAfI7y8eMs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220266; c=relaxed/simple;
	bh=vnJaOoqEMNO9ANjXUlK0ZBAZb70RWQQcroY6eyo15bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zq64DNn3RTOsYjG5HNzT+05tefteLdAU+jBowW/h0eelbMG7UoYUr1GMMLGTxNN7vnyOy4AZ/inGdhKMfbidFfdPo+/71W48lY3omn2vJ1BLbgeJcEXBnRV20sddqWylLISeXQlOZChebzSjB9ozhQoK8kWHsbE4ZaiZqxq6Acw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNqoYI5R; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so6616687a12.0
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745220262; x=1745825062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hjAs9RcrgTzwyo2uVRhaBcOduDtjP+EEgWj98SYJDkM=;
        b=fNqoYI5RSBPMfsO94FYfKuXd5SabUjFI8IfnGYAVPm/D1EWEZboN7bz+Qu3mSCLNIz
         mkGS0DvwfSKYu1V7mb/rDHW2/PBTxPG+MEtb3EfbnxhG3MlISBF2JHM1saEpNiV1gh1W
         OPhodEP7FjdWDdfoOQyVLQ3ZD//vfVJe/SF8MD8+zrDBIrGSZK0jUjIbV5odxr78duFd
         2lVLQKbnqmi50072ScSJpXHwthQp+/sA5A65kzTX2rzba2jdZurUHsN0ua4SsQJXlLI1
         9T9eg0cgOx/Bm4I40n4XLE8OVcHgrVEJcMpAlBORWw2h0hhkmm2v6SGWJ6YvavqbIFGs
         RqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745220262; x=1745825062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hjAs9RcrgTzwyo2uVRhaBcOduDtjP+EEgWj98SYJDkM=;
        b=gHN1BrulL8jSmmm8ICgGEJWGx5cpxUi9DwcMxnpkRn/AmoePYUwTw+WxllgvAzayI8
         Kiip2jgEhf6o5P6RDwFQMrE75xeRUT0ikOJOdDIbHdv+0NOnHHLNrwNXhhq7CaDhH39X
         eVbT55SaeW92z4U6nnLDA3E9zC5XEleny4DPJJjzLV2cellNZQuKgfulTcLdYhMCilOu
         WXWnuJFdCGzkLeytat7rtL8stm/SqH2XUKB9rMdIqjmVCsoDcebIQaMurhTHnviqK2L5
         CZtxTs9OBuLwhxG4HqQiGcoUOBWbQu+RTkdxL5yn0vvRL9bWt7RpyXpCmqWMYYQH78tQ
         TcaA==
X-Gm-Message-State: AOJu0Yw1Olss2tgPuPXu+oPqTOVRRU+LcxLeT31Ew6RE7BRf12E7AYs8
	qQoBKNBE5UL62h8npaxE8Sc8CH2N9+4KGswJOMqXfXmA/uOyxw6gqu8PtQ==
X-Gm-Gg: ASbGncsfyri7HRGR7xUsQ0pah7HgGYKckbO4I+o/QKajRh6X/isUGCtTlUwLcghHtjh
	6pM51/M7EQtj/S+5qJFj7Fsj4UXcgpCFPT+YoWZX0XGiYm2WairmeII/sZWJ/MtjlxfnwcFuwsU
	SkMVAKD7Al48cqs9/s8g+xIUGPk/nmFcKZaQ0H3LcJq1b0UZ2mqe5j1muWS43tWWSVRU5B6Uef1
	Q6ur1y2rFv8JmhAZsdJHFz1fUtm5FUYSHlmtQjE4Zyq1f99yVA+rWj6kS0d0mYj6uWnyjl8OVSb
	s3gcrugxdRPkn3/pfagnZjh8QpwN49LJxsWawN7ycSzKmsFMQTRaog==
X-Google-Smtp-Source: AGHT+IHTVSsQy7UQDbBB+k13Swakazm7qhyR7RHCB0buWTHmyMljYAyGMlDbiJ2C2E1d+0dhZkgYJg==
X-Received: by 2002:a05:6402:354a:b0:5f4:d605:7f5c with SMTP id 4fb4d7f45d1cf-5f6285e88ecmr10816064a12.22.1745220262058;
        Mon, 21 Apr 2025 00:24:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625a5ec5bsm4175562a12.81.2025.04.21.00.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 00:24:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2 0/4] zcrx refill queue allocation modes
Date: Mon, 21 Apr 2025 08:25:28 +0100
Message-ID: <cover.1745220124.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Random patches for zcrx. Path 1 removes oneshot mode as it doesn't
give a good example, and Patch 3 allows to kernel allocations for
the refill queue.

v2: rework oneshot/size limiting instead of removal
    fix flipped allocation mode check

Pavel Begunkov (4):
  examples/zcrx: consolidate add_recvzc variants
  examples/zcrx: rework size limiting
  examples/zcrx: constants for request types
  examples/zcrx: add refill queue allocation modes

 examples/zcrx.c | 119 +++++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 51 deletions(-)

-- 
2.48.1


