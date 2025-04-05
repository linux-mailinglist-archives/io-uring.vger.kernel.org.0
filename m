Return-Path: <io-uring+bounces-7417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8305CA7CA65
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 18:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53E851741C5
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 16:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15AB189BB5;
	Sat,  5 Apr 2025 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b="JIPtWlVN"
X-Original-To: io-uring@vger.kernel.org
Received: from yourcmc.ru (yourcmc.ru [195.209.40.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78755157A67
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.209.40.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743872297; cv=none; b=nWixf4xV3xEmtm7E03qy5eahCFfZsLWC0qpeMvNf4U/yRshh24Vqf0VvjDsBymF6yzynthZeEyBvnCnVPWMK/lxc4n1jtF0ikuYUOCLN6xVX6xnmkHcU9zaMvYOOnjNhBHTAPgV004HoZ2Bj16F/fF1wUiEIGA795g/qxbt7+Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743872297; c=relaxed/simple;
	bh=tl4orWJzO1i+scDCnHwk15Zag81/+7SA2ZNQfpji4nA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To; b=iJDj0vUt0g6a1CoPall7GKmLSxBzqviC0Hju7ULgTTKqORFfAi1phFXyBFiNwxM/at4BgpLocrx9AxGTkkv/0B+iWIREbMR35tMFnYBKMVAewSqhSTSbkTaAd53T9HupBQqjdNpUhgOhANu+jwUVqTfrPEhR/Y2ZY/hzTyf27mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru; spf=pass smtp.mailfrom=yourcmc.ru; dkim=pass (2048-bit key) header.d=yourcmc.ru header.i=@yourcmc.ru header.b=JIPtWlVN; arc=none smtp.client-ip=195.209.40.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yourcmc.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yourcmc.ru
Received: from yourcmc.ru (localhost [127.0.0.1])
	by yourcmc.ru (Postfix) with ESMTP id C2604FE0665
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 19:58:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yourcmc.ru; s=mail;
	t=1743872290; bh=WirSA8hUBknd5Uju0xyuMaCIq/jw9AJt8yWJsJn4tDM=;
	h=Date:From:Subject:To;
	b=JIPtWlVN63rigQrT7ks99PybuIH3X464uqjmv70qWbW2aQGQP7bZzKWlnGHf1qK0/
	 oWAU9u/JoEEEoAxP/KoJMVq2acvqGilzPTxR+lPFnFhmn56hMuCOoQeW1rYZG2ni+R
	 unkNIKA33xJ3McB15pjiRbGTIoqQgsWCsX6sSvGq8LcDe66XMqaeddUir3oBVa0DOT
	 7TXBL3vr3eEMDOXtirhne9Ez4xNtIZGnZnnwAcpiqA35F89Rl+VDV5nyfwD/ESHzsu
	 ICGL94XLB7m5iyNVmsuVRMA9KfelXhOr4Q1Z58e0ACmwk66BukaUiAuH60YasvEGT7
	 yxCilt0k7mPeA==
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
	by yourcmc.ru (Postfix) with ESMTPSA id 9AAD4FE065E
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 19:58:10 +0300 (MSK)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 05 Apr 2025 16:58:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From: vitalif@yourcmc.ru
Message-ID: <f1600745ba7b328019558611c1ad7684@yourcmc.ru>
Subject: io_uring zero-copy send test results
To: io-uring@vger.kernel.org
X-Virus-Scanned: ClamAV using ClamSMTP

Hi!=0A=0AWe ran some io_uring send-zerocopy tests with our colleagues by =
using the `send-zerocopy` utility from liburing examples (https://github.=
com/axboe/liburing/blob/master/examples/send-zerocopy.c).=0A=0AAnd the re=
sults, especially with EPYC, were rather disappointing. :-(=0A=0AThe test=
s were run using `./send-zerocopy tcp -4 -R` at the server side and `time=
 ./send-zerocopy tcp (-z 0)? (-b 0)? -4 -s 65435 -D 10.252.4.81` at the c=
lient side. 65435 was replaced by different buffer sizes.=0A=0AConclusion=
:=0A- zerocopy send is beneficial for Xeon with at least 12 kb registered=
 buffers and at least 16 kb normal buffers=0A- worst thing is that with E=
PYCs, zerocopy send is slower than non-zerocopy in every single test... :=
-(=0A=0AProfiling with perf shows that it spends most time in iommu relat=
ed functions.=0A=0ASo I have a question: are these results expected? Or d=
o I have to tune something to get better results?=0A=0A1) Xeon Gold 6330 =
+ Mellanox ConnectX-6 DC=0A=0A-b 1 (fixed buffers, default):=0A=0A       =
    4096  8192  10000  12000  16384  65435=0Azc MB/s    1673  2939  2926 =
  2948   2946   2944=0Azc CPU     100%  80%   58%    43%    31%    14%=0A=
send MB/s  2946  2945  2949   2948   2948   2947=0Asend CPU   80%   57%  =
 52%    46%    44%    42%=0A=0A-b 0:=0A=0A           4096  8192  10000  1=
2000  16384  65435=0Azc MB/s    1682  2940  2925   2934   2945   2923=0Az=
c CPU     99%   85%   71%    54%    38%    17%=0Asend MB/s  2949  2947  2=
950   2945   2946   2949=0Asend CPU   74%   55%   48%    47%    45%    39=
%=0A=0A2) AMD EPYC GENOA 9554 + Mellanox ConnectX-5=0A=0A-b 1:=0A=0A     =
      4096  8192  10000  12000  16384  65435=0Azc MB/s    864   1495  164=
6   1714   1790   2266=0Azc CPU     99%   93%   81%    86%    75%    57%=
=0Asend MB/s  1799  2167  2265   2285   2248   2286=0Asend CPU   90%   58=
%   54%    54%    52%    42%=0A=0A-b 0:=0A=0A           4096  8192  10000=
  12000  16384  65435=0Azc MB/s    778   1274  1476   1732   1798   2246=
=0Azc CPU     99%   89%   92%    81%    80%    54%=0Asend MB/s  1791  206=
9  2239   2233   2194   2253=0Asend CPU   88%   73%   55%    52%    59%  =
  38%=0A=0A3) AMD EPYC MILAN 7313 + Mellanox ConnectX-5=0A=0A           4=
096  8192  10000  12000  16384  65435=0Azc MB/s    732   1130  1284   124=
7   1425   1713=0Azc CPU     99%   81%   82%    77%    62%    33%=0Asend =
MB/s  1157  1522  1779   1720   1710   1684=0Asend CPU   95%   58%   43% =
   39%    36%    27%=0A=0A-- =0AVitaliy Filippov

