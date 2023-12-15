Return-Path: <io-uring+bounces-286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B01814D78
	for <lists+io-uring@lfdr.de>; Fri, 15 Dec 2023 17:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F28E21C237A6
	for <lists+io-uring@lfdr.de>; Fri, 15 Dec 2023 16:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D9437169;
	Fri, 15 Dec 2023 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0Oh6OqkN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21623EA78
	for <io-uring@vger.kernel.org>; Fri, 15 Dec 2023 16:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7b7117ca63eso11839039f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Dec 2023 08:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702658910; x=1703263710; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWdiI9YN5t9aa4+d707SgTNdP8AkRhgVBphOBWY3Yu8=;
        b=0Oh6OqkNurIPFO5wMkBXQLFNOMmgwXm35SOXvZOA4bs+XNe8peHYOJKSsyrvW9Fqwa
         diQrWR3FTAyOsafLmigbe6OY7TI3dr0PYAfSrSfMNi6C6E7iZ8mTzXeVmXJS1JCaLKg5
         kiUlLy/KG6oIuNZ5vyHkb8eFsbfXuv8/n/Pb0fUk326MD+4XoKgNkTZqYOLFB8qrqemS
         MRswoBNIllF+ziRII15ShbzESWoZD2JF1jVSDZOsl4/pVdbwrbvSFMWo8ZBEZXv2WIp5
         ZoRs4+Ir+sxMSp4asbK2SFJHGQAFDRGPlCuwIgvVzLNIvSeKH9o/uo74/z8yMyyz/V+6
         j56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702658910; x=1703263710;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oWdiI9YN5t9aa4+d707SgTNdP8AkRhgVBphOBWY3Yu8=;
        b=JSPcAaY70ghVtUtwPt1jbORdwsIt6R/1GPouNdhPlMu/DXWDmFDcHPlBfB7/VSz04H
         AylBt5+L55lj3PCx+8ceOsaqW27jmlNXKKrd0y6tMJz90BxKLoct8wRJLZO+Aq25gVy5
         0JINyuBfUwB1KyXI+BirOhCVgs2XP7S3kALdmN2Xzu0ZlYve7zTkuz8K6Lc2c76Aa9uP
         clX8mpNUZaYL7XdofiO4lK/kCbVGfwm7sxJ3U46/wit5JIbCjawm4AFhfELed0tp+K1+
         EFkn/B4RGOFflvdPzspDZ7pIN1CEWQtvzk2M/36unJQnxn7WgBenH7F+DY8m5Dg6eoBU
         XI3A==
X-Gm-Message-State: AOJu0YzU+IloVuNK3PtOvsSRC3fToz+M2FzD6xXaifETwXySlla55mAW
	H/KllmIy27Ag9bFFreR0z5bZ35abMz9SqbyOXr2UjQ==
X-Google-Smtp-Source: AGHT+IGP2V//8fcJBnT9dUtVRUBDnmYGxgSWmAu1HsvO4ZuPDH7rHY7eF7dcYw0PovQ56B3IYCldiA==
X-Received: by 2002:a05:6602:257c:b0:7b4:2bdf:5a27 with SMTP id dj28-20020a056602257c00b007b42bdf5a27mr20230763iob.0.1702658910577;
        Fri, 15 Dec 2023 08:48:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g12-20020a05663811cc00b004667167d8cdsm3970657jas.116.2023.12.15.08.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Dec 2023 08:48:30 -0800 (PST)
Message-ID: <3c762dfe-f297-4b2d-b7e3-b0306fee349b@kernel.dk>
Date: Fri, 15 Dec 2023 09:48:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.7-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just two minor fixes:

- Fix for the io_uring socket option commands using the wrong value on
  some archs (Al)

- Tweak to the poll lazy wake enable (me)

Please pull!


The following changes since commit 705318a99a138c29a512a72c3e0043b3cd7f55f4:

  io_uring/af_unix: disable sending io_uring over sockets (2023-12-07 10:35:19 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.7-2023-12-15

for you to fetch changes up to 1ba0e9d69b2000e95267c888cbfa91d823388d47:

  io_uring/cmd: fix breakage in SOCKET_URING_OP_SIOC* implementation (2023-12-14 16:52:13 -0700)

----------------------------------------------------------------
io_uring-6.7-2023-12-15

----------------------------------------------------------------
Al Viro (1):
      io_uring/cmd: fix breakage in SOCKET_URING_OP_SIOC* implementation

Jens Axboe (1):
      io_uring/poll: don't enable lazy wake for POLLEXCLUSIVE

 include/linux/io_uring_types.h |  3 +++
 io_uring/poll.c                | 20 +++++++++++++++++---
 io_uring/uring_cmd.c           |  2 +-
 3 files changed, 21 insertions(+), 4 deletions(-)

-- 
Jens Axboe


