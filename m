Return-Path: <io-uring+bounces-8418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A04EADE97B
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 423CA7A5ED5
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 10:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7534E27F4CA;
	Wed, 18 Jun 2025 11:00:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953B1219E8
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244457; cv=none; b=WZkjbzdmQ83JxQFBY3EoIa5bJPPz4MaGoIiTdLCDKbBJ0niYvy8lWpGiCNvnzTLvtAoBiICmViDBqb8JpuUcVbZHdUL9HUiuQvDRJi6EJ6nAlQhr7iqKGvaXuenLYWJneC201gO59Gmg6rKolHgFODQc1mom2tPeNyv5Kh94x8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244457; c=relaxed/simple;
	bh=qU0BFER2rePO4qyG/FVdaDKIKGSPjsHZXY5/OW4slRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZUTtZUfM8CIokJszf6KxCitL92K4JIPfBYT1oV33Zd8Ro5m8kM9alPU3uzE5iHMjDTgJNNByYFYveapSutgWrFASlK1de9BFcy40PwV7v8m+wRX0VwT4g3fk+aCzhIUIks77bKilEDbyBGs/oX/4mRXEz5O4kaZ2COvOMTm8n/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244441t28aeae6f
X-QQ-Originating-IP: tQxrf/mAOxYeZWVxDHW/ojr31KJKhWklGigCEYJK+4s=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7250821614920196361
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 0/6] Add uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:37 +0800
Message-ID: <F4067414386D6471+20250618110034.30904-1-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: NvGGTAUhB2iW2LgfpLMQdi0U+9c8G7u7qwdwMYTvRoR4aSsHh8nqhJRB
	VnSVa2NtgHG6Z/Apg4v1uTeMF9Iv/6elTyfm2TW1qMGsHi9OfycapC7KOwTMhbBZQCD+uGF
	vsHJ92a0z/vSi0L8t56Wz9/SUt8+gkiyKALm4GJnSt2WZQ4f8pVroq+3Z7lf3PgjhN3+jL8
	Xup6viDzFoshihscm+cf7t79l2Q8ZB1BC380vCV0bTo5I5RDpGI8AVI48l91ZMHaiVxSROG
	eagrjFVWTAuS+qctYV+6Uj45F1h92MxupwNhZoAYEhNEEPar1LB9y4PMQ6MhPEHQ0RXo/Ck
	0clDOA6kkp397+ZCMkX5rGYiRV95CcW5J4CvbyNpEcXJBrNhE/OX6Sk3D0bECazdgwkctCm
	BtTGmPdFKs+fEDQ4V/yGADTPy1zeuvKgig+JQdNzyAIcbIcCm3DY+vtH2OITm2Zt83FeI2o
	wAvxsVy6Xadj3wxqoGR46jLG/Pl36o3BbmaKdmXlHoCI8liQLoeXfEpCFVH5j7NLvRQLsDl
	xPmEDSUp5HZ2BLBeHKKXrO62KD7h3gQL4U2jySx2zqFN+/Psgzo+oaDQtNm1ae8lIVyx5l7
	D4VRMlBcSHcO3R1FpdD5Ch88BYxlAChef2FZTCjgPS4UUmQ1fm9CIu3IAklPGlNOOlQZAAw
	Ua0tQx55cEXHEAmZcGWQN1F2/GIVIBmObjzKtjrO2U6PbMz1/wOeH6EQ1XoY6eS/BUdGUw7
	/1DMiJlVFCP4QXAMwW0aKp1MCm6fxkzzJVEV9hjSP8C4tlGAjnB0F9b6kCs5hUTs7mD79xv
	yAsAIemPpWRqzrF5bY+e0uXvwdLkw1YzmqCifQVtZ6XAEBTsR5X6nm/rE4xILigz6IdirRw
	A4v8axVI2t9CjT+QEmfC9KlCvrY2cPtgSrzwdbOVPUtPkIAmr6NQ2bomSbroivkahK7zCQh
	1OL7xSj9h/TBJzHLtxYm/dnXJh/yZ2KZrbW4FJh7TyR9JEFitfp7nvPwybED0Nub2K5Z6gE
	6Zb7joIL/0x9Hukkvl
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Instead of '(__u64) (unsigned long) ptr' by hand, define a helper
function to do so.

v2:
  - Move the uring_ptr_to_u64 help under the comment 'Library interface'.

Haiyue Wang (6):
  Add uring_ptr_to_u64() helper
  liburing: use uring_ptr_to_u64() helper to convert ptr to u64
  examples/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
  examples/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
  test/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
  test/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64

 examples/reg-wait.c    |  4 ++--
 examples/zcrx.c        |  8 ++++----
 src/include/liburing.h |  9 +++++++--
 test/reg-wait.c        | 24 +++++++++++------------
 test/zcrx.c            | 44 +++++++++++++++++++++---------------------
 5 files changed, 47 insertions(+), 42 deletions(-)

-- 
2.49.0


