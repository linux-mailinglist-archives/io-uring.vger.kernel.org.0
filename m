Return-Path: <io-uring+bounces-682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE7F861BB6
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 19:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7F1A1F26A7B
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 18:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD32111A4;
	Fri, 23 Feb 2024 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SM1IU5a4"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DB4101DE;
	Fri, 23 Feb 2024 18:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708713241; cv=none; b=L+a1ixt46PE1vFVncdz3W3G3T76RRan8AraljVk6FRQYyAxdD06ElLefZIXwxdwuMlG9aPxk/MNMVvDg3PSSZXGg15EnZGFnSUFi34rQYqMVB4Vw8zhKITXA+mHEaQiL3G7ZjVHAR3DzHbUO7CcK9IGsteUKrESiuduQGDBDeqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708713241; c=relaxed/simple;
	bh=W16s7HsLRKeMogf+4P40NdsqJiCC7rUspv0L6Ekrt7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rl541vZPu4amQbSs75HuxToTVKYCMZbOcDJYuNHjxS3XEkAdVhQQOSPdYtx9dD3siUhliA4nZdULOlRQVDOij0Xw7GNPuhpcG8ploTi6VEoXeUf4TecdQsHDnuX4e6YfC6Bmxd7A11QAEEx+O/M9mRi+/s4AItagHNUg0Oc8zRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=SM1IU5a4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41NEnafk007025;
	Fri, 23 Feb 2024 18:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=Kfo/C8zqynWW3khr9w38fLA/juhM//M+1TSK7YbUzao=; b=SM
	1IU5a4CNIWLmOnc+jXipb4Ga9eIJLWms0rnPxEXMwHDSoxe92W9Ew+cz2UneOT08
	Iyi2XyxnbZDa1t3nXppWD2gBv5baFGSu5jpaJXHu6vAsxhujSo74jXQc1qhtrkyj
	b1JYz/cxWMolVJrmsIH4767eZriXHsfPc1ASRZIKs+Vh4MImjLRwoZRf+c04IWja
	WREgwfvGpnGGa1IxPu7qJXJNToVvZY2M73nvMYmrwiDnSM6QuEXhaYYJoUiQlYDP
	AVkDtm/36vZFGTWQ5CsU0kJMULpTBDkWBl74wMVr5RZuQ0KaRJ0q/8gb9Xik4nP2
	o7j3uPWaxue4GCbloFJw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3we3233ydp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Feb 2024 18:30:49 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 41NIUm69006076
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Feb 2024 18:30:48 GMT
Received: from [10.110.104.142] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 23 Feb
 2024 10:30:46 -0800
Message-ID: <0aed6cf2-17ae-45aa-b7ff-03da932ea4e0@quicinc.com>
Date: Fri, 23 Feb 2024 10:30:45 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
CC: Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <amd-gfx@lists.freedesktop.org>, <intel-gfx@lists.freedesktop.org>,
        <intel-xe@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
        <freedreno@lists.freedesktop.org>, <virtualization@lists.linux.dev>,
        <linux-rdma@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <iommu@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ath11k@lists.infradead.org>, <ath12k@lists.infradead.org>,
        <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
        <linux-usb@vger.kernel.org>, <linux-bcachefs@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <ocfs2-devel@lists.linux.dev>,
        <linux-cifs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <selinux@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-hwmon@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-wpan@vger.kernel.org>, <dev@openvswitch.org>,
        <linux-s390@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        Julia
 Lawall <Julia.Lawall@inria.fr>
References: <20240223125634.2888c973@gandalf.local.home>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240223125634.2888c973@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: wCcVNA_rPgQQt00obewLDHJucphy8QWk
X-Proofpoint-GUID: wCcVNA_rPgQQt00obewLDHJucphy8QWk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-23_04,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=793 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2402230136

On 2/23/2024 9:56 AM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.9 and submit it then. Hoping
>    to keep the conflicts that it will cause to a minimum.
> ]
> 
> With the rework of how the __string() handles dynamic strings where it
> saves off the source string in field in the helper structure[1], the
> assignment of that value to the trace event field is stored in the helper
> value and does not need to be passed in again.

Just curious if this could be done piecemeal by first changing the
macros to be variadic macros which allows you to ignore the extra
argument. The callers could then be modified in their separate trees.
And then once all the callers have be merged, the macros could be
changed to no longer be variadic.

