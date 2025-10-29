Return-Path: <io-uring+bounces-10285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BF264C1DAB9
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 00:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E561E4E43B1
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 23:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC2F307AFB;
	Wed, 29 Oct 2025 23:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="vx797a16"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18DF2FFDF3
	for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 23:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761779819; cv=none; b=fsFvKSSNbtNcX1STggW35O9J3ShNG5HhrApYiwuEqCH4qrHfa7Lxjc4NhLRjWACyO9RE4uljNkoK7NitpHQwCekAfVhm8u9HT/EVlWTcJIBC6QjQY9ACPVtKsZad66odN6/SR+PDKNat2bE5H6Iz568cFrvjz6t+h5ncpRGU6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761779819; c=relaxed/simple;
	bh=JUeejtpj8GTJk/bWvRgUfL4yXr1jHbbKuz4+egibNgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1s6MkAGzOqs2Hp8Bk3mqR/hlfBnPYaUNusr/N8S8CpHw0zITZXD0QI4WRx5qt0PAslDOG1hItc+Af4FHKDbRMaNVyNZKhF+sWdsJZ/EeYYfKttEd9WX1mfoeBlyzp19K3EOMOljZVAk4viXjLYt0fg07XZVCgchZI4p+D/jpqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=vx797a16; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7c5333e7099so247216a34.3
        for <io-uring@vger.kernel.org>; Wed, 29 Oct 2025 16:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761779816; x=1762384616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W9npAGNAvB/GkXlLNAKo8gMpxVLoAPVmTQZH+Cu98zw=;
        b=vx797a16GhyevlG6eW9xdv6oVXq4ZueRsiBdYmoOlTeNukujb/YgUFKor7WcGMlTGd
         E/9V6wsQFkB3rr8mhS9mIkSkmASqDudOCfRDBejtaciHsGKKGRT1q8lv/Pp09Cts0gG1
         FJDUChH4Sde48oq7NYKjzKMnkLHM34FM6TZ0omb2ZQkl0k19yFhp1dyEwncvy0VOsoi0
         UlFq1+jZWvt8yQI7RqQtlIoW4VvBE6QqptOs5JARwBqblJuXXNnFuHBCrkzlMsBsv+lF
         iM3CLXCt67AeinNOuuAF2CLL5T6r9biIfqIQdBO/hJFN4BwmdOtVX6Bi+m721Kp/HArP
         Q+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761779816; x=1762384616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9npAGNAvB/GkXlLNAKo8gMpxVLoAPVmTQZH+Cu98zw=;
        b=RwCcRanKBUeXZl6f6LomgbO4w4eb78pLCT6yH7RZau0dgWLYJPEKf9PQpDw263HRVa
         Ktp3eyNgSAPmfwHzdiucQqT85qmiREeIoholK3BGGNmN5/yQgyk9A6UC7FKfrH3kosm8
         Q5kVY12e39FeVEiDml5Gpxb6ogCvhUEBQAKI54h7D0ceNGHRjIx34IvfaJUBi0+QlGH0
         wI3I0OMo1FPriWboWxi96dz3nVVqhXrBEpA4oDc4L3sUBJR/sr7L/CyY5wNoQh9Yk9TQ
         ASf0ZQ3X8rRVd4cccDXQtke5DxfZkK/OvNSdPdpp8zsKR0cWMVi8IEgLDs7SakopNYCj
         o0qg==
X-Gm-Message-State: AOJu0YzIJYyd7yX7ZmFu2K00XglGzbpKFE51uyq/9Rw+NJ59PhaJshbM
	nTq4tOUUSAPrhufC5qSu1WiUYzTKJZhu3hQozq1vSYyfuu7+FQS4JLOu+B2z03grMg3Zjh522d/
	O0QqZ
X-Gm-Gg: ASbGncsDV1La7thx2swLU4X0TI9quml24yIqL5Xxp4l9HhRY0/FX01TEyxP3zteFDlE
	uX12szWGZzNVtJ7x5cPyKM9sdLM16uvORtIhcvAdNYmDTjjYXMqdxf25DzUeamZgppmY9p5PsSc
	0eUTaa7MdkSr86s248kLBAHV2DP0vckfZLQAB/OmWbc+6Ld3biQojOBedXmZX0GMfcU9ziW+nKY
	RRCgqg+FsJHDa26+T8YbcKAOmXuf4RKvKhqNuTGHz4E0nXf+3WTIfsLwBvbjdP5xHx11YDjFNPD
	mq51TPiPqbuBK8xDssSiyZobN1VXAADVK9o5KMV6DcvfkNMACfY53AH+Mfq0GZKGc4NfpRltbQn
	IyKPb4w8TRwD1agKBpHMnjuZizWhqJv7q14vOaoHlo1uY7N/5ubSkJeLSP0cqBrkPOU3J2nc/EU
	lVEeCpZXKxJ4lQubMtDhg=
X-Google-Smtp-Source: AGHT+IGcWOsufyfCBaHb0HQVZelrHAbKEeNnGWYfHdRQh0ZHXnKFny/zbfmewmRP+D3U0mdDU64lLQ==
X-Received: by 2002:a05:6830:6a96:b0:757:aee6:4a59 with SMTP id 46e09a7af769-7c68cf4bbf6mr753917a34.18.1761779816418;
        Wed, 29 Oct 2025 16:16:56 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c681eb5595sm1336806a34.3.2025.10.29.16.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 16:16:56 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v2 0/2] net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
Date: Wed, 29 Oct 2025 16:16:52 -0700
Message-ID: <20251029231654.1156874-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev ops must be called under instance lock or rtnl_lock, but
io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
Fix this by taking the instance lock using netdev_get_by_index_lock().

netdev_get_by_index_lock() isn't exported by default, so the first patch
is a prep patch to export this under linux/netdevice.h.

Extended the instance lock section to include attaching a memory
provider. Could not move io_zcrx_create_area() outside, since the dmabuf
codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev. Happy to do whatever
here, either keep this extended section or relock for net_mp_open_rxq().

v2:
 - add Fixes tag
 - export netdev_get_by_index_lock()
 - use netdev_get_by_index_lock() + netdev_hold()
 - extend lock section to include net_mp_open_rxq()

David Wei (2):
  net: export netdev_get_by_index_lock()
  net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance
    lock

 include/linux/netdevice.h |  1 +
 io_uring/zcrx.c           | 15 +++++++++------
 net/core/dev.c            |  1 +
 net/core/dev.h            |  1 -
 4 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.47.3


