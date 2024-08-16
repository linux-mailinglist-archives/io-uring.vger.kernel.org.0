Return-Path: <io-uring+bounces-2798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3AB955128
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 21:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 269D0B2281B
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 19:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C70F80638;
	Fri, 16 Aug 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sXWub0Va"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287191C27
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723834845; cv=none; b=pdImzNLQrJiDE1KgSWSf/0Yv2bEAqz0peiPsMuzvxWYfQC76ERjEULhJAWIIEauECzr0NiuwykqHJYnEqj1CzkIOgbO/vDrc0SzcTet8A14V5BiFCXyONvp5kdTAnVSuWBOzSQ8WpnaOxkqspbJlUg+G4Re++b8jLy7BX3niykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723834845; c=relaxed/simple;
	bh=EWu8DxF89xOWaOZ1T7NaU0xHMPbC3cJn0uh8R1otylA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=gEJEF5dZ0DWNYO99vRuhckoo+yxOditLX6iBQPtbn1LxCSxu0HY4HJm5SKdwuhFIPq9IbOavkZXvUhvIw1JbmYds8lw40zvrzMYng/NaT2JyvlO07OCaOi5Hby7e6Bkk4S++gMw+nGXx7ECi8uSbHVGvk7Sx3+EimkDso4469BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sXWub0Va; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-81f8bc5af74so5545539f.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 12:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723834840; x=1724439640; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76QsmedoCcHscl7sjUJxz8OZRHnMOMQx+ojx8Pxfvig=;
        b=sXWub0VasS5hHInctcLj/Wu6I95Hjx52oPVOqZfTbGd6ziOIimWh8+KG9qzK75bTJq
         j4QA8RWlBErW+jmIN6iiA+kHwtrjvJ/K6iyhk6l0H7ZQo+v1iid4wPuyUDSKurvh9QL6
         LmmzKphfCC1fPIVswbAQgQj9N5QeJsWE8yi0Z0u+NnP6nV4Ju1fjRMU8+QRZyNOvdhYS
         INJfinMe1NZXOKsyxenXkNkiRJFlWYAls6NkUb8mhYdAAp54fmL5TkWzLOEzUBpiNEw4
         EYKoDSWANoaBrpOtcpNmZAAo4tBlqr6e/rs14mYNT2src3jv5shnctqgI3EOC6WvUCik
         D1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723834840; x=1724439640;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=76QsmedoCcHscl7sjUJxz8OZRHnMOMQx+ojx8Pxfvig=;
        b=eIhiUsjsHMl/QZugMpH/ttan0EsMZ6m2vlJ1SGOtEcLCXuuwgFAEDtNJUFMCGBshLr
         mgBCfjxtsc1SA6azQhBb6l5OaWvUdeem3KX/0r1EhiXDCbt5VsM6BZpojjI9ieP6qgIu
         rjGXxgOYFaZJOSZ1H/lnDyrawW3fbP1/QIL4Z1FIxdsbFLy8oUNg8ayEOV18XKwH71aL
         31RKNs/8732R0SjGeQUhM+Yje/+Xeqrh9pZ3gRaRQ+dLjw5ytX1nHDai8sImiKveVSPy
         eWLnDn4+Ccvuw4POlEIiHxlm8yLtS4UK3P+IUDfLnL7f/3LVpg8hxMweLhXxObIEIEiu
         1Fhg==
X-Gm-Message-State: AOJu0YzM0OpfJ/5nNMtj0tOR7V5jBiLV4MCfZ21ggdOLKM16/RwvMRWr
	tCHmRXjldgMdwwukwAfJUiN3ycmpXZQi8DgJsFx5N+vYBhZnNwJdNWAZZBNNIjrh+jBW1PjlrPO
	+
X-Google-Smtp-Source: AGHT+IHlIUmPS9L+vBK9NeOR2nC8o1S1Y31NjHxldzXdPoQHsjW7M1fZmEk4MgHcpsD4CzLWQYtAHQ==
X-Received: by 2002:a05:6602:334d:b0:81f:922a:efdb with SMTP id ca18e2360f4ac-824f265be4dmr270776839f.1.1723834839939;
        Fri, 16 Aug 2024 12:00:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-824e9b5541csm142927039f.38.2024.08.16.12.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 12:00:39 -0700 (PDT)
Message-ID: <7d38d674-e5ce-4311-80ba-d9c8e267c414@kernel.dk>
Date: Fri, 16 Aug 2024 13:00:38 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.11-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes and cleanups that should go into this release:

- Fix a comment in the uapi header using the wrong member name (Caleb)

- Fix KCSAN warning for a debug check in sqpoll (me)

- Two more NAPI tweaks (Olivier)

Please pull!


The following changes since commit 8fe8ac24adcd76b12edbfdefa078567bfff117d4:

  io_uring/net: don't pick multiple buffers for non-bundle send (2024-08-07 15:20:52 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.11-20240824

for you to fetch changes up to 1fc2ac428ef7d2ab9e8e19efe7ec3e58aea51bf3:

  io_uring: fix user_data field name in comment (2024-08-16 12:31:26 -0600)

----------------------------------------------------------------
io_uring-6.11-20240824

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring: fix user_data field name in comment

Jens Axboe (1):
      io_uring/sqpoll: annotate debug task == current with data_race()

Olivier Langlois (2):
      io_uring/napi: check napi_enabled in io_napi_add() before proceeding
      io_uring/napi: remove duplicate io_napi_entry timeout assignation

 include/uapi/linux/io_uring.h | 2 +-
 io_uring/napi.c               | 3 +--
 io_uring/napi.h               | 2 +-
 io_uring/sqpoll.c             | 2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

-- 
Jens Axboe


