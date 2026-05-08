Return-Path: <io-uring+bounces-13259-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAHDKuJX/mmupQAAu9opvQ
	(envelope-from <io-uring+bounces-13259-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 23:38:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4774FBFFD
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 23:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F8673018BDF
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2026 21:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577D331715F;
	Fri,  8 May 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bTsVEFyG"
X-Original-To: io-uring@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F64533121F;
	Fri,  8 May 2026 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778276317; cv=fail; b=IU+ygRuJl9yHoL3IdE4YjOvB7+XT/zkQiUxDe6Xe4sE39f46DvJc/tRyGCogrAB/ckS7bCNLGogislMD33T3tTI0+n3n8XCFmp2gf7vNtg8MNP2l4+7tkIreRqi0r3SHOJgJ7hZthj/wU1Uf9RxEulJ/UXhRRDM0/1npaXRdP1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778276317; c=relaxed/simple;
	bh=md4nrs+biNwmMf1hX3gNs6f/fryPnkB0MSm2ctq3MmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ecGO9UXglVP53WRRHyruC8nAPWMNHi0eqLFn9GoOKQ5paNM7ocDB0f7i8iqHWJP/0S7VpYv3kB6htTBRLWWS4EHa7cWsjM5jsp1ZWWDZ6TEMaGs2bcBQxrbg97NsnbjQFFH6rJ/GNkQd2MqjpbaqdGdVfMhg43PCf9Dp5/uBhLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bTsVEFyG; arc=fail smtp.client-ip=52.101.56.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM7ATG1YVcxhb26vcogtVyw2FQ15iLG6sR3hnZXXRUf20Bs7HqGLYvkgmqPPnByJSFfC6c+wkaZjP9tFlMBNRSxGeQjZcUSyUxTPPJ+JBTEH5yahMd2HBNhdmlPqjViAP8fn32/VlLZ/bo0TdzlgzCPQHbwNR2yPXgJVlQzxgnr4aOv8FBNgnSorzVhVjVNk4iHFJP4gJ/n5MmFN+N9eFJdraWYNFgbIvMgztMK181D04/F2CWJ5606f7oE4ka021/q3sDxNY3fab1o1opaWTCJrRhU99kCyebYGBLLg6hz9UKsarOgHaTcIIFuJ1crQzk68eNeUh3JarUNlUqDlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+7SGP7RIRjvFMD5jRyHfPqdjpBrycuF15t8GVumfNo=;
 b=T9re3mIDY8EUFlYakTU76wh1DNPAgPIhp++cQtNX2rXmak6p7veCl93DGiUdcJPkfT+LECxtR4wg+ob4913jLRG2+8e1m/MipOxt4PFYqb6tXAnn0PuqnWvwTEyK2F2xWKwsFQiI6LIkQu9qsAOYy8KDG4zaE+XXiAGuKTGJ0/BktvSJo7dHvz3qxz/JXrXYW2TzH04cyWejsUpCqlM7p/uMnrjqId3W6Xu+shv9EPNbsRdeDbS2JGQ1cPMbfFMA6zyYw9rCgXjldfkcHGNjYy4aMf2jIVtxu79Q5KJCNIh20gx/lWDMmmfhfn3eZ8WmA8JcUl/+6aJjfChQXVKpYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+7SGP7RIRjvFMD5jRyHfPqdjpBrycuF15t8GVumfNo=;
 b=bTsVEFyG/fLlEWh4O0/l3y3vYYTGF2h8CU05VRt5zDi6GKIwcTAted1VZ5pINkVlO3Ak/LQQ/xTynb8I0xSUIKAlUSZMwinE74ICuQUbtUgudiUMvYigzY2x+0oDRL8eG57ApwPXYjV02GYsuw1bdVZkome0wPZ6xHZ++tJ+l1HD8c+vPX26lMAHTcdwwyvsmGfzC7L5wpGgkecYlvQ29tadYvYEuxFOT3MNYF6Z1TOBGk9sD0yv0eb35ev23aO3SrcmBAZ/SWJf6qpDpwZi0uoazSjQqNpyyn9nsGYmFMNeq/fI4dyO0B/gVUziyU/P4wewuIp9Wh6A6TeNR3hnAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 21:38:28 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 21:38:28 +0000
Date: Fri, 8 May 2026 23:38:18 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Changwoo Min <changwoo@igalia.com>,
	Clark Williams <clrkwllms@kernel.org>,
	David Vernet <void@manifault.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
	io-uring@vger.kernel.org, rcu@vger.kernel.org,
	sched-ext@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] sched/task: always defer 'struct task_struct'
 destruction via RCU
Message-ID: <af5XymUlyE0Jsi2t@gpd4>
References: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com>
X-ClientProxiedBy: MI1P293CA0028.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: a8a64df3-001b-47cd-93a7-08dead4a2434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LtvB6DmctTB034I+Bm3SkJZwr1spWD6lV6RW9WZGKkNRvqAkH05IOJP8fGOih4giIheNmnwZVXwr47w6SDzUVz8d2xG1ty1Z5SPvN0jjqAOV299QMH4cNoni4F7KEWNA49dTI721N6OsPPMy3b1lTCy6L1EW+j2duFV5/ihCIpeJh0171QknDM83Cni7SUl904I5hEsnKGPDffrXfZRNclJgcFzjrnd2bdJ8whSrXtInZWG1LNSrrWNKOLwyDFZVu34fYi5AxlEMdUd4KfPKX1XAA2Mr2aL2QVpZRGbst4PNq8KR5nQPl6KGVVGwcvJ3Nbt8i9cOys/HYTl1uVTZwhC4ZHVpnSqBkymqyLrC41vapUpd70tbTnX75lGXxMukuZjOPiOksCYL3ixta0w50VmKOqtzLrG6ytagfdf7c6twhNw4ZvyXv/bvu/HJU6nkJ40M/KLa41peF7vfp0z1egedy59hvoEAJbFff0i++RR5hhEdp5MpJtG64KnyLkcfLJZp9D9ScR9VGhAUoEtZ4QdzpXA8EkBaHCxfTOFvYLGgSenHV58M0jcymqsmX9WhdsTJ7hXo8AW2WBhdzi5p2TtXRUjnjp+HUMlBRYdgB5hf4JFfFZq0+IXHLMTOZjPy1l5UVnRJqvKbGlGujfXR7IZYHp6YBd/lQR0eYiGix75RjWUs6Moym2kEdrws75zw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h8HmnCG5V8ygZOkVBGX3khtuWvmSkfjqrWEj3XfLev+C59Y87pPpRvnMTYrD?=
 =?us-ascii?Q?NuIfocKNAZOKJ+omtqOIn20O+rLmGoFaiB/hj2ZjXnnFlxS2IV0chPb8ejhx?=
 =?us-ascii?Q?bHr2gGKqpEl7HsjfRNhQbhCNZ9GAbwbK2wnACJmQE7rEXjednmADmHcXoi+v?=
 =?us-ascii?Q?O4modk7y1FIkl0I4P2lwJfUsxeqnuEqDrxPwiyi4EFgtn1DNXvydIkuxuY7T?=
 =?us-ascii?Q?pAWzdia7pUIoqP0VW2sX/iA/shAKtEBfPZF6WAYw47iKED3GYgghAXPkdxrD?=
 =?us-ascii?Q?rICLt0rB657Ea3fjbysngzaIZlaX1ogozw6xP97pvGvObkppxCoXsnBa6R1J?=
 =?us-ascii?Q?VrHGhGouNJvM2QF/MKt6TdjYCNJlw7derShh2nGlq59VAjagDd796rr7h5Bd?=
 =?us-ascii?Q?ypNJlIHJyhYnisvbF+fjxFX9ZKmPyAIvyP/jpR1lxh5gjGqKlYvvQPztkaAx?=
 =?us-ascii?Q?w2VZLOiycYnun2JaRk5+VrkOr/2t42559MrUT2uvkq+aJci8cRg9kaXj77KE?=
 =?us-ascii?Q?DJ7iZK+S/d1nGNBGp/A1Ly8oGJwm36YMRAqT63eLXsGBfTrzvCB4BwKy92nI?=
 =?us-ascii?Q?MP0G5gOLbQSETS62eQCQGLbHfjEXCiQ1T/IgzDXdDLoxHuNNAUnUCK6V/YFg?=
 =?us-ascii?Q?m8V4PKqkdp31oVbGqWRD1kXGE2sxK7/UfFXwbvxmRLmF8yHkuJX7/QMZ0NMu?=
 =?us-ascii?Q?wPRfiiLVM75yqJ3yfHz1kV6XCV93ARHzC+dlszOqeZt5+GCc71qlrkTpZCc3?=
 =?us-ascii?Q?Ldf7857jULxj1yb1UaX/ZMfcb1TKPYUUk3vAfrvZyTsC7y4Q5/8MO54M8ZJk?=
 =?us-ascii?Q?0MkncTwTNggDj/BN4HjoCRVptm8iFEtn5oK145W2WFwMxgB4TscRX+F6DTAt?=
 =?us-ascii?Q?halC6xfqHwo+46UiSt0BmhW0RNoG5RDv4WYfPS9U0+qkmZ7juWmZI0pk7ivo?=
 =?us-ascii?Q?HVR3c535g50hjaAxUwT2CFP7PDQNO6oU/YnMqq7Xp8yPxJRVzPOuxc9D0Uzy?=
 =?us-ascii?Q?P6i6xAgNvbnqHgQsud5X7QK7kAwFKinLkUQGCEK5s+dO2YH70rixsncG4ZI8?=
 =?us-ascii?Q?43cY7i9CQQuPl9ZvxMiKlEKDke3bYzyy8HBiVR0zU+FfUU5/icD6Yz0In+Ds?=
 =?us-ascii?Q?VLfAynF4bqS27k9cYHFA5cf+DckyWTwDBmfVICQHazgBI9ounpbdttDno3h5?=
 =?us-ascii?Q?TsTJUi1k+jRsUDjLP7ykaZiI+RywQDaZZdP7Ofv+rV/+mX6nWPadUlldz1v4?=
 =?us-ascii?Q?zLAR2uPDOk0Y9uSMioOa678Xb2D9c66bI4vrpGWT93dk0CO/DbGiLsdS8pc3?=
 =?us-ascii?Q?tlfMETIV88y9p64+N8mKKWpejOGQeExpnmV6C5QsSYht7mi94QqNMEr8nHIL?=
 =?us-ascii?Q?XxTJ9meBGl9vSmH5PjqXrsaOAfe1ugkeWgokLrUvnthSFPVDah4/LN1xxrZ2?=
 =?us-ascii?Q?mD81IjJuGodXHWnOXwQjutKGJjrxqjHMpnaapXMNWNxnk57CT3MLu0pr1xJH?=
 =?us-ascii?Q?+ibtlzXhnfqkW2WTCslHzvIweNAhpaqMT6aryv0yvNzyssWgWspIdwt4A0/S?=
 =?us-ascii?Q?h2P7v9hws92+k5Nq6YkRspJEpD1Jbkd5xT8/jv7RoJ0Q4H0mts8vzZTWjsKc?=
 =?us-ascii?Q?WG1SPpx1311XoVbapyZgLgHHwKp6SKUr8xGOkkmbUtg51ZDIo3CgBJ3tSZ1C?=
 =?us-ascii?Q?TtcwAuXTNCcX8fLz/sIDZLYkb1nWWpfLRcUTMLjRCZ4wVFy93BhEjKI6vuZN?=
 =?us-ascii?Q?3zi4Dlp9Mg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a64df3-001b-47cd-93a7-08dead4a2434
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 21:38:28.2409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53pahj4fIlk3wDbPndalgPcpiqw6ItzmgVH7SjlzR9SZZxHz+FajC5yfbdlDoNQHBytVDz20jO4B+WeUa1bIoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972
X-Rspamd-Queue-Id: 0C4774FBFFD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,igalia.com,manifault.com,redhat.com,kernel.dk,nvidia.com,joshtriplett.org,gmail.com,efficios.com,infradead.org,linutronix.de,goodmis.org,linux.dev,vger.kernel.org,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13259-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[arighi@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Hi Alice,

On Fri, May 08, 2026 at 02:02:45PM +0000, Alice Ryhl wrote:
> The sched/task.h header file currently exposes a tryget_task_struct()
> function, but it is very risky to use it: If the last refcount of the
> task is dropped using put_task_struct_many(), then the task is freed
> right away without an RCU grace period.
> 
> This means that if the kernel contains a code path anywhere such that
> the last refcount of a task may be dropped with put_task_struct_many(),
> and it also contains a code path anywhere that tries to stash a task
> pointer under rcu and use tryget_task_struct() on it, then if they ever
> execute on the same 'struct task_struct', it results in a
> use-after-free.
> 
> The above applies even if the RCU user drops its own task reference with
> put_task_struct(), because if that is not the last reference, then it's
> possible for another thread to invoke put_task_struct_many() and free
> the task less than a grace period after the RCU user called
> put_task_struct().
> 
> There does not appear to be an actual problem in the kernel tree right
> now because there are no in-tree users of put_task_struct_many() where
> refcount_sub_and_test() might return 'true'. Io-uring invokes the
> function from task work while the task is still running, so it will not
> decrement it all the way to zero. (Note that if I'm wrong about this,
> then it's probably possible to trigger UAF by combining this codepath in
> io-uring with the tryget_task_struct() call in sched-ext.)
> 
> However, the current situation is fragile and error-prone.
> - If you look at put_task_struct_many() in isolation, it looks like it
>   would be okay to call it in a situation where refcount_sub_and_test()
>   might return 'true'.
> - Similarly, if you look at tryget_task_struct(), you would assume that
>   you are allowed to call this method for a grace period after 'users'
>   hitting zero. (If not, why does it exist?)
> But if two different kernel developers anywhere in the kernel make these
> conflicting assumptions at any point in the future, then the combination
> of their code may lead to a use-after-free if there is any way for them
> to interact via the same 'struct task_struct'.
> 
> Thus, as a defensive measure, we should either make
> put_task_struct_many() use call_rcu(), or we should delete
> tryget_task_struct(). This patch suggests the former because it does not
> change anything for any callers that exist today. (As argued previously,
> the body of the 'if' statement is dead code in the kernel today.)
> 
> The comment in put_task_struct() is also updated so that nobody changes
> its implementation to only use call_rcu() under PREEMPT_RT in the
> future. The current comment suggests that would be a legal change, but
> it is similarly incompatible with anyone using tryget_task_struct().
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Including sched-ext and io-uring in the cc list as they are the only
> users of tryget_task_struct() and put_task_struct_many() respectively.

For sched_ext I think we should be already protected by scx_tasks_lock.

From kernel/sched/core.c:

  finish_task_switch():
      if (prev_state == TASK_DEAD) {
          prev->sched_class->task_dead(prev);
          sched_ext_dead(prev);
          cgroup_task_dead(prev);
          put_task_stack(prev);
          ...
          put_task_struct_rcu_user(prev);
      }

 And sched_ext_dead() in kernel/sched/ext.c:

  scoped_guard(raw_spinlock_irqsave, &scx_tasks_lock) {
      list_del_init(&p->scx.tasks_node);
      ...
  }

Now on the sched_ext iter side:

  scx_task_iter_start();                     /* takes scx_tasks_lock */
  while ((p = scx_task_iter_next_locked()))
      if (!tryget_task_struct(p))            /* still under scx_tasks_lock */
         ...

So, the locking gives us the invariant: while the iter holds scx_tasks_lock and
observes p on the list, sched_ext_dead(p) cannot have completed.

And the css_task_iter paths have the analogous ordering.

That said, I think this patch still makes sense to provide a consistent
semantics between put_task_struct() and put_task_struct_many(), as mentioned by
Sebastian. So, maybe reword the message around consistency rather than UAF?

Thanks,
-Andrea

> ---
>  include/linux/sched/task.h | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
> index 41ed884cffc9..da2fbd17b676 100644
> --- a/include/linux/sched/task.h
> +++ b/include/linux/sched/task.h
> @@ -131,19 +131,25 @@ static inline void put_task_struct(struct task_struct *t)
>  		return;
>  
>  	/*
> -	 * Under PREEMPT_RT, we can't call __put_task_struct
> -	 * in atomic context because it will indirectly
> -	 * acquire sleeping locks. The same is true if the
> -	 * current process has a mutex enqueued (blocked on
> -	 * a PI chain).
> +	 * Delay __put_task_struct() for one grace period so
> +	 * that tryget_task_struct() may be used for one
> +	 * grace period after any call to put_task_struct().
>  	 *
> -	 * In !RT, it is always safe to call __put_task_struct().
> -	 * Though, in order to simplify the code, resort to the
> -	 * deferred call too.
> +	 * This also has the benefit of making it legal to
> +	 * call put_task_struct() in atomic context. We
> +	 * can't do that under PREEMPT_RT because it will
> +	 * indirectly acquire sleeping locks. The same is
> +	 * true if the current process has a mutex enqueued
> +	 * (blocked on a PI chain).
>  	 *
>  	 * call_rcu() will schedule __put_task_struct_rcu_cb()
>  	 * to be called in process context.
>  	 *
> +	 * In !RT, it is safe to call __put_task_struct()
> +	 * from atomic context, but we still need to delay
> +	 * cleanup for a grace period to accommodate
> +	 * tryget_task_struct() callers.
> +	 *
>  	 * __put_task_struct() is called when
>  	 * refcount_dec_and_test(&t->usage) succeeds.
>  	 *
> @@ -164,7 +170,7 @@ DEFINE_FREE(put_task, struct task_struct *, if (_T) put_task_struct(_T))
>  static inline void put_task_struct_many(struct task_struct *t, int nr)
>  {
>  	if (refcount_sub_and_test(nr, &t->usage))
> -		__put_task_struct(t);
> +		call_rcu(&t->rcu, __put_task_struct_rcu_cb);
>  }
>  
>  void put_task_struct_rcu_user(struct task_struct *task);
> 
> ---
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> change-id: 20260508-put-task-struct-many-5b5b2f4ae174
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>
> 

