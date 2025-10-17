Return-Path: <io-uring+bounces-10044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F24BE7C25
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 11:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C682F6E120D
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 09:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5C0298991;
	Fri, 17 Oct 2025 09:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fxsL9H51"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F2B1ACDFD
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692703; cv=none; b=TcYgCi0kizPaeTv5vzHBQmM4bOBafapy78OsvtQv/ZttTn8j895dRQUqwYUZFxwG0yCWHl6oF5d3yPljADt+L20WYuJhaS0nyN0BYjPiEgI5MJBeMju6tEHeMrjJK91wh3NzgOVygBNSdbRI1wl3+lRlxXwBaVm4564TwFMAX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692703; c=relaxed/simple;
	bh=JkPVVdrPmlmTOUgJi1pFAq99L+0EF5ysO3v90EXy0WQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GBQEPkFzVAtGdRGTzwZE3obWYkIw+PFxFm+CQiFaNHUFGIaVt4zPz8lxBYXwbG5qfd1ayjeZcKPx4ZU4Yq3pbd/p1P/oHyavEpYyNYGRd5y2agtEXMSEjSx+kfXp9cy5n9/NbpceLBGdDElhR+sg79vwTV1NCMks1KZ70ibAVno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fxsL9H51; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251017091812epoutp033286157b430759e4f83bd0da63ad5194~vPKzKdBHY2549425494epoutp03d
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 09:18:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251017091812epoutp033286157b430759e4f83bd0da63ad5194~vPKzKdBHY2549425494epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760692692;
	bh=WLpos5VJo4ujXC7f9pS+oruhgvFGdqlCqiZ4Y8/B/4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxsL9H51OoGjzDDhEzccIStzUJfmjkiF9GULaDdG3uICkuJSC+D9EBneUSaBZZ8dV
	 eX6N/NslvSb4LZ4cy+HtBtWnS4iPx3UYn+FQ+LV2TpKoyW/XkUc67XJygY32WMJKC4
	 0Qc/L0IfBL8q0lPkP2+S0WV3Xak50cWySFIx6gyY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251017091811epcas5p448adbd977948e060e0b4bab514410484~vPKy2TskK2886728867epcas5p4e;
	Fri, 17 Oct 2025 09:18:11 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cnzkg1NJcz3hhT4; Fri, 17 Oct
	2025 09:18:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251017091046epcas5p35dfbcf4979f79b3a80441aed2d31a906~vPETq65qD0737307373epcas5p3y;
	Fri, 17 Oct 2025 09:10:46 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251017091045epsmtip18c89641ac9655ac1aec28f880b817f27~vPES5nsU-1493014930epsmtip1J;
	Fri, 17 Oct 2025 09:10:45 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: changfengnan@bytedance.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	lidiangang@bytedance.com, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com
Subject: Re: [PATCH] io_uring: add IORING_SETUP_NO_SQTHREAD_STATS flag to
 disable sqthread stats collection.
Date: Fri, 17 Oct 2025 09:06:15 +0000
Message-Id: <20251017090615.6580-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAPFOzZuhDU0yD=nGioR1a3u9C0ZXxOpahZxv=PsHThEJJK=A3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251017091046epcas5p35dfbcf4979f79b3a80441aed2d31a906
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251017091046epcas5p35dfbcf4979f79b3a80441aed2d31a906
References: <CAPFOzZuhDU0yD=nGioR1a3u9C0ZXxOpahZxv=PsHThEJJK=A3w@mail.gmail.com>
	<CGME20251017091046epcas5p35dfbcf4979f79b3a80441aed2d31a906@epcas5p3.samsung.com>

On 10/16/25 20:09, Fengnan Chang wrote:
>On 10/16/25 20:03, Pavel Begunkov wrote：
>>
>> On 10/16/25 12:45, Fengnan Chang wrote:
>> > introduces a new flag IORING_SETUP_NO_SQTHREAD_STATS that allows
>> > user to disable the collection of statistics in the sqthread.
>> > When this flag is set, the getrusage() calls in the sqthread are
>> > skipped, which can provide a small performance improvement in high
>> > IOPS workloads.
>>
>> It was added for dynamically adjusting SQPOLL timeouts, at least that
>> what the author said, but then there is only the fdinfo to access it,
>> which is slow and unreliable, and no follow up to expose it in a
>> better way. To be honest, I have serious doubts it has ever been used,
>> and I'd be tempted to completely remove it out of the kernel. Fdinfo
>> format wasn't really stable for io_uring and we can leave it printing
>> some made up values like 100% util.
>
>Agree,  IMO turning off stats by default would be a better approach, but
>I'm concerned that some people are using this in fdinfo. I'd like to hear
>the author's opinion.

We use fdinfo statistics to evaluate some of our internal test data. 
Initially, I tested the performance impact of adding this feature, and the
results showed that it had little impact on performance. Therefore, 
I didn't consider adding a switch to control its use. However, 
adding a switch to control whether to enable utilization statistics 
is a good idea.

--
Xiaobing Li

