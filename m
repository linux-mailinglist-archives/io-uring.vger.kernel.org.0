Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BB3248D9
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhBYCTy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 21:19:54 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58956 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbhBYCTx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 21:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614219592; x=1645755592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=usRwGxXtNgdfvaD0IDTHPloRFDBcqRCDnFv+mPHXXic=;
  b=RPHWPMzgNe0cxuZl7BGrXM76V2mW14VHWEO6mlEvyYHZIZTqAfCmUJhq
   vi6OjnGOQgdhRcHNIEjdv/YkI99Hl/xx7e7vkx4H+tVBeAX2l4rhxBB88
   k43RGARrL9eEnkrR8C5DpuHAQ/OWRVPMY+lSYdYa/GO1zrR6JatJ319ql
   mApQdpWy2fsXStS/xcqHbBgGiSgT98f1ABgLr7VpT0orc/i8zRZmPkK/T
   VXgAZhWoNxXHxDy4DRrgUDvuIlCLaR2cyTCFlHADDIOFveEm5X7Mq8UkM
   v/ZZuqO+AsmDpXQtLbppWzO/R6A0i9oAcMltFuc+dKxw72dfrHhH49FeR
   Q==;
IronPort-SDR: jGWMGiIQyq5gXjXIG4/jjonJzUH6CNRHD0C56c4YQTeYn6Toiw2auCUHjSyk4a0MVqNEhH4lVj
 +WYD+onLQEYgAy0DJXSmgyGhdsM49gJp9Xz/iCFYuCZPNv07eD79eYb64A5i9hw36pK7SW/T/c
 JAjrlGzFIu9Ozwo8W4lcuSV7cHWZMFntH0pjIE/Gv6/b9W8Mc3kMZ4Be5+zYXV6gNn9psDqNal
 UYeh1GH2Ns0SnapqtbDQDGLfTD8Lyz1JfXlNzIj2013G9vUlN8IEMDDJsVxEGHudFJAU+T22Gy
 TsU=
X-IronPort-AV: E=Sophos;i="5.81,203,1610380800"; 
   d="scan'208";a="161915051"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2021 10:18:46 +0800
IronPort-SDR: IPSvnBG1D7HCZbi1LhlMedaITzXMJ4R1R4AbJzKwWnbpDFukRLs7ump15pF1WECR3/oz12j4bq
 Huf8Ic3CRiJjOigqpXaNVffIzuQQqwu5V2exuPd1kWqTQi5wZNeqMm9UrzdQfrZdgzDdAN8ZYG
 MBJyalVSYe53BJAyP8CBsTtUoWUHcpuFzs6TO7evnjD6moc9JNjwjXMm7zFqxZ9CSbzTJi4TI4
 HtACSMw3/Szoa8DN+IzaUpByFEpTZ25H0+gMzvv7xXk/mpZRTXy8BJDa6FTQrMRiuLOfBRaaIa
 3PNwM7OXjeZFvz+SfV5ZDQbG
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 18:00:08 -0800
IronPort-SDR: iurXxsRz0USqZsXEMKxI6WJ06T1/sjj1+nCaQu4VhMy+OGcUW5vWzkBVCmCgZyaG+BOKLTbv/v
 B7bmXlzfE3irCU8ZG1pInlyKPNiFbHYnVDLX8O3tqkw0EeyyHWKUiI3pg7FVCDPYtJMx6fz9Cn
 wroVyUSGWO6jgsAE3EqF52e95AFpyrSuPW45JoKTKygEpKdsDu2R4D2KY3GevlFii0D6wOCTz9
 nuPKmXJS2udklaab04R3zvfBJyZn8diFnANG9Eumwb4/fPYaIx8F2l5ufX+12lA+A/GcVMs99x
 l9Q=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Feb 2021 18:18:47 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH] io-wq: remove unused label
Date:   Wed, 24 Feb 2021 18:18:44 -0800
Message-Id: <20210225021844.13879-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove unused label so that we can get rid of the following warning:-

fs/io-wq.c: In function ‘io_get_next_work’:
fs/io-wq.c:357:1: warning: label ‘restart’ defined but not used
[-Wunused-label]
 restart:

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---

Without this patch :-
# makej fs/
  DESCEND  objtool
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CC      fs/io-wq.o
fs/io-wq.c: In function ‘io_get_next_work’:
fs/io-wq.c:357:1: warning: label ‘restart’ defined but not used [-Wunused-label]
 restart:
 ^~~~~~~
  AR      fs/built-in.a

With this patch :-

linux-block (for-next) # git am 0001-io-wq-remove-unused-label.patch
Applying: io-wq: remove unused label
linux-block (for-next) # makej fs/
  DESCEND  objtool
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CC      fs/io-wq.o
  AR      fs/built-in.a

---
 fs/io-wq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 42ce01183b51..169e1d6a7ee2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -354,7 +354,6 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	struct io_wq_work *work, *tail;
 	unsigned int stall_hash = -1U;
 
-restart:
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		unsigned int hash;
 
-- 
2.22.1

