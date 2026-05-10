Return-Path: <io-uring+bounces-13265-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBOrC+LQAGoMNAEAu9opvQ
	(envelope-from <io-uring+bounces-13265-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 20:39:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5EF505B5E
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 20:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 553BF300B13A
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 18:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB213115AF;
	Sun, 10 May 2026 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pBv4R7pA"
X-Original-To: io-uring@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F714A4F0;
	Sun, 10 May 2026 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778438219; cv=fail; b=c1khLcuq3BdDxEDfIjgffPIUiixbhLBRQXL6ODOXQAyZ28ewqrNiwTDlK+qWzSViTqfiH0NC/NrGkgUQUvE4kZGGncYOV5XjxSvL6asXwXViYp3j6rgHsxIbi2nxfa2hr1mHqlAFqo6LgQ8fK3HjcaLIb6uXGX4fkuL63CcxLjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778438219; c=relaxed/simple;
	bh=3rRsAO1Hi3k0aWPXMeC9jKl/wNCljCvOzVgcYXs/yeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=duEY9SdO9QD9ORpTUi2hP8mCHvY37IjKsOIwsKOZq2KZjx6JnoDqVo3mRNUt+Ug6uhMPybp5FfbX0y/djnif2dL7UR7TsehdKbES1JKnRb7iDzacNoaQXZMFzQbSxpukI2qAxCiBltcurCa1wvIlHDNr/10yB5XbQYf7/5mOX4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pBv4R7pA; arc=fail smtp.client-ip=52.101.201.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sILG9deQJPCZt0TX/NYL0infPrpkNhoE3C7Y2w970cdB/PMUTC/6KrK12/IZkM4Xt03p/l4XpxQ1q8vVJVOrnZ2Q4z4+pNH3KE3ABtYSaNd2auAueTy6bTpnOdaBjTozEQ9FNLYP8l1gT8OrDc+ME4VPaMqBl57kEfiPRwDekFpRi1PCUO6fE1V/D9qvuLUReOvCTQPh6MQwjSVA//RMRVLR4giQUtbe+bDyJ6BKQCtJiOMUB6khzoCmLJ4OPbzDtv2DzLWLTbR4V+JrCSh+X7RUJZiKZfBMKFyER2FxqCRmqi3ME8SBUq/FQHNodlSMJCwfantG3yIIcMOD+IeSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6M2hQUUo2JcMOjaFO0fTo4/X5QugDjhqsXB2iF6xmR0=;
 b=QrnYiyDy8SDcLdw1yIYK6VC7YE2tCpmVono7dNOuHuuT7xNZXIcTb1ZJfONi3uDEuN9blxlXt0n1sAbRbACFYm7amTx/xIuoFrKolAB2HfjZpuHMp2aFX1ZMO3TLUd46gOiBSOZERzMM1gLSrGnXSw6KLvaL8JvwAUXFzClbBDx87Q8d5vih+6IEFBjKarjqQVRTJyEIfnQzfjRxkTXmyOgdGDKZFQ+1D9hKO1j2sOhZYn71wFn/uubFtfvUg/Je+cs3GkVyuM/aB2QMw/mUw3pFEF1DCNL//YuNhK6fKRRWyjC7bkqzkJti9yzWPI4I58vziSXk/Idp8t1ZR7bVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6M2hQUUo2JcMOjaFO0fTo4/X5QugDjhqsXB2iF6xmR0=;
 b=pBv4R7pAijNU2503456XZOEi7vYx8K4JoXqYH0F+/uKqCdRwlvSTDEz2TkLp5okt+sUkVV9aCgiUMjJ1Z26pOvupDysFNOdh6hp+KeTHA8Iiwx+0Vf5KUYEZdKaZmw4AB1EELCO2oWKC8sCECoT8BkU+hkSHG22S6d/T7trXhYAOOVByPDcMF7dLL9QdYPnp3whe6PJNwMQ2F1xepVXwJFVXCC8agtxLGxPm0VR/TgMag8VMXh8iiaKvt6HKxlHfqHdqIovY5nq8RzFO6UvKCfO4MR+XSQna6GZk12SpC9k0JUEkL5dAR1wDmhIGm0f5c3OxtsogJ6fSzGqOLk6NPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5806.namprd12.prod.outlook.com (2603:10b6:510:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Sun, 10 May
 2026 18:36:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.021; Sun, 10 May 2026
 18:36:54 +0000
Date: Sun, 10 May 2026 20:36:41 +0200
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
Message-ID: <agDQOf8Qe11ozpuf@gpd4>
References: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com>
 <af5XymUlyE0Jsi2t@gpd4>
 <agCLBxHEUqWIepx8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agCLBxHEUqWIepx8@google.com>
X-ClientProxiedBy: MI3PEPF00004E9B.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::457) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b9c736b-d0d8-49ca-462c-08deaec31bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9nDG7FLFiUTP5PV869rNqEAe3wtttkdY2Ub6H1koxdUJeDnhzkZWUwK9z3PZXSQg+upHPcQI7MckIoP4hHeHXAnkGQvGsgGq9DWZKz48KNXLxQdZlS3elqay5PmBZ3JMNo2u6wHdfU7kCqDkTo1FsbJmh3hchhwWhsUiOUKxwnjxcKp1CZ6MEx8WmPj6V6NedvoPSOkU8WJPIKa8ymjmJR6r99LlpooJWb/dObZuvieQkuiJm8V57H+vAav8M5oD5NAcvcVzPtJYN0ROAEfVWZZIy5/D0gKVSQrIJSXnhDAjvG02DYvAsL9htocInQsLIAsR4Xtg2u7oXb8LTuetad3hsep0DVMd1p55RfKvuu0CCxBeVZOHAmRZDTccoL0uA9xcr5gSpnBSohBZNmWx+cEQLcl7IWbWHfSWVtuotAe52jeBCzXJirFe2fNdf7s89zFMOgDmqUznHPV5wMzu/D/EYMmfR/0GJ2V1eOEpo1KOC8rIVI2Gcu74SwiO2/6fAzdQc/esrHERUTNN4AI49YMVQ5grTBgXz1RdMsuXYctBxOBdyv4zt6wqDyJWJBn4p3P5u2baLgfRfirYRSHEP/jvesQH++C0mBhAu8igl/iCW7noHKqN+30BQnYenM2+fIxmxD1NXlHJm+nMm5RnmKhF4N8ovJhETixtdGqCfGAoYkxXAi8lPaEqnqCdhV3w
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zIsJdII9FCNAYGQ9AnrF+errycYiKawbyFiq2ErZwY18CzPQwQsWx1P2V7K9?=
 =?us-ascii?Q?xxLPTVdzqUjkXk9FFUTJXgY1+RP638jp7wkgwhfo9gDZDbNbBFAhx75cRpUI?=
 =?us-ascii?Q?K2I6uHzlWSqV8wY7HnPjBHLsSQ+aIRJ4grt+GrPVOxmMI8rQFf5DFbD3JvDF?=
 =?us-ascii?Q?WeNMJQRYrYaQpNNii1x154FEWltEZx7mnv5HWq+CgizTycGqt2yYFmSdCgSF?=
 =?us-ascii?Q?ffFsTqHRhQo5/hUKJbEvA1jLN3vt/6vsk+F6ck2qhBh2f/SdBWbT6GGXGN09?=
 =?us-ascii?Q?Lal6aotZUxpdmhoH6Dg7nYqtWWXAlwZlwjqRr+WivYSMtmi+NYYrZGoxfbQf?=
 =?us-ascii?Q?V7zrpVXdVjCC6pdBll2vLNzaXxekIyJIvU+/XF7HdR2JbMOacW3yITfmRuqd?=
 =?us-ascii?Q?KOWRyBw2dxmLgDaUXHPN9PV+eC1Voj/wVbRtL+w93PbisB3shp2aH61WQBJ/?=
 =?us-ascii?Q?hdffCdrYUjoh++oPIIkGGIItUkH7lFHbE2BBa5IEAktzJ2LSuETI4ZdBnFiE?=
 =?us-ascii?Q?DveNGdzC2hez/y+7SWA0CEqtPG1Vpe70QI8KhCEKfPOeehIUedlLtCXB6aXr?=
 =?us-ascii?Q?1kYGN943gW4wwhgSMQWrnWedI85D9VlibznZ8XkjIZ8aAmgzZu0OdX64DgQV?=
 =?us-ascii?Q?0wy+m7bPH8Bpf3X5A2diXqTNopIkKeIGRc9dcHf0O/HxeOdR02KLi5/JcKwy?=
 =?us-ascii?Q?wqzz6sdj005h/0Scno2NIqMtHckJc6z9nFRbdNGqojAxbm/ilC1qWyWPlMB/?=
 =?us-ascii?Q?WBoN5GIRqgeN4RWvuSyW0iXxadSdfdqqjHpcLKtw3OXM+oDF1/JpltrrhT+/?=
 =?us-ascii?Q?LhLCxKnHz/Icpawmuf/YuSxV4f4KAcJS6o0R/oQRSePMgwtDXOJsKUBTxD1P?=
 =?us-ascii?Q?hF3QFNapyilG7e947KbgpQ7kgkh03WhJC3EDYAnqEXyorPmq6a9XFdO74+YQ?=
 =?us-ascii?Q?iEOdkq/P7pTDtNA75/5zeosjwF71NLiKqPTe+CXI35If9h3NnKdbW68UjtO/?=
 =?us-ascii?Q?3RrB+Flz+P2A+HvC7IP683ikLc8uB6omlKeEkYVCA8dsV2lsvV2EeLo0xpth?=
 =?us-ascii?Q?LJPKFSLuNkd2n4xcRtfl8kBJMfFzIZXXhecpWmEkDV7H5l3ZVIDqSDfLfvjT?=
 =?us-ascii?Q?jfkunFymFo1tt2GTH0XsAE+fyxG7IagiDdCLgQT4kCjjX4/HuMUiNHRe8o6w?=
 =?us-ascii?Q?w38LZEUUcDpKzq6hrYcaN4vVZ+ZT/nqjkxGrUKtcYZrAhzIUgZJUasJ5PHWN?=
 =?us-ascii?Q?VmhSMw1XYq+yWRX1E7U2BtArJ9QExmV3nAFyWlzdOTX9j53cpHXJxKbrdlmd?=
 =?us-ascii?Q?hgZhhkJdpjdRvy7pd3dYMD3dqko2uxM89cDArs+Lyin9+fSLQ55/l79Ecnkq?=
 =?us-ascii?Q?O3nPmyGYnNBUKfIrUdWqfOY2A66mrknsCNw1kudj8iMAGSDANWMwzRuva38V?=
 =?us-ascii?Q?q6JwdLd40p00cTG7QicBrY/PaglPqpSCd7fMK/LDh/UsjwO2tDx6l72kZNkH?=
 =?us-ascii?Q?fF+Zlc0vWjKHQtXEGZaiD+k3WR8+rLakAJTa7NG44fLzTKRwQbjTUitKrexi?=
 =?us-ascii?Q?uYBjh1BD4dpTFJFpqOK7ok46Lt80uSB3bXaenzaJYLfbUTvkKKenCSS2OkPN?=
 =?us-ascii?Q?7fVxvjzJJqrL3hqI4TiTdQY/SR/tEVSkdkVAyOyLIOnodOajoYjbLZx6WmI9?=
 =?us-ascii?Q?AW2qt9Qrx2HinGXWABYBTS7UcFdH2L1QNRIWo+yUpVYmEp4Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9c736b-d0d8-49ca-462c-08deaec31bb8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2026 18:36:54.3372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f43VXm5JAGpeaJ2zbQimWFejHyK5S9p/fr/UFNBdDu17/74XPR0PY2NhMt1huGnDdEBJQs9MTz/gtc/icxDKFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5806
X-Rspamd-Queue-Id: 9A5EF505B5E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13265-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,igalia.com,manifault.com,redhat.com,kernel.dk,nvidia.com,joshtriplett.org,gmail.com,efficios.com,infradead.org,linutronix.de,goodmis.org,linux.dev,vger.kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[arighi@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim]
X-Rspamd-Action: no action

On Sun, May 10, 2026 at 01:41:27PM +0000, Alice Ryhl wrote:
> On Fri, May 08, 2026 at 11:38:18PM +0200, Andrea Righi wrote:
> > Hi Alice,
> > 
> > On Fri, May 08, 2026 at 02:02:45PM +0000, Alice Ryhl wrote:
> > > The sched/task.h header file currently exposes a tryget_task_struct()
> > > function, but it is very risky to use it: If the last refcount of the
> > > task is dropped using put_task_struct_many(), then the task is freed
> > > right away without an RCU grace period.
> > > 
> > > This means that if the kernel contains a code path anywhere such that
> > > the last refcount of a task may be dropped with put_task_struct_many(),
> > > and it also contains a code path anywhere that tries to stash a task
> > > pointer under rcu and use tryget_task_struct() on it, then if they ever
> > > execute on the same 'struct task_struct', it results in a
> > > use-after-free.
> > > 
> > > The above applies even if the RCU user drops its own task reference with
> > > put_task_struct(), because if that is not the last reference, then it's
> > > possible for another thread to invoke put_task_struct_many() and free
> > > the task less than a grace period after the RCU user called
> > > put_task_struct().
> > > 
> > > There does not appear to be an actual problem in the kernel tree right
> > > now because there are no in-tree users of put_task_struct_many() where
> > > refcount_sub_and_test() might return 'true'. Io-uring invokes the
> > > function from task work while the task is still running, so it will not
> > > decrement it all the way to zero. (Note that if I'm wrong about this,
> > > then it's probably possible to trigger UAF by combining this codepath in
> > > io-uring with the tryget_task_struct() call in sched-ext.)
> > > 
> > > However, the current situation is fragile and error-prone.
> > > - If you look at put_task_struct_many() in isolation, it looks like it
> > >   would be okay to call it in a situation where refcount_sub_and_test()
> > >   might return 'true'.
> > > - Similarly, if you look at tryget_task_struct(), you would assume that
> > >   you are allowed to call this method for a grace period after 'users'
> > >   hitting zero. (If not, why does it exist?)
> > > But if two different kernel developers anywhere in the kernel make these
> > > conflicting assumptions at any point in the future, then the combination
> > > of their code may lead to a use-after-free if there is any way for them
> > > to interact via the same 'struct task_struct'.
> > > 
> > > Thus, as a defensive measure, we should either make
> > > put_task_struct_many() use call_rcu(), or we should delete
> > > tryget_task_struct(). This patch suggests the former because it does not
> > > change anything for any callers that exist today. (As argued previously,
> > > the body of the 'if' statement is dead code in the kernel today.)
> > > 
> > > The comment in put_task_struct() is also updated so that nobody changes
> > > its implementation to only use call_rcu() under PREEMPT_RT in the
> > > future. The current comment suggests that would be a legal change, but
> > > it is similarly incompatible with anyone using tryget_task_struct().
> > > 
> > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > > ---
> > > Including sched-ext and io-uring in the cc list as they are the only
> > > users of tryget_task_struct() and put_task_struct_many() respectively.
> > 
> > For sched_ext I think we should be already protected by scx_tasks_lock.
> > 
> > From kernel/sched/core.c:
> > 
> >   finish_task_switch():
> >       if (prev_state == TASK_DEAD) {
> >           prev->sched_class->task_dead(prev);
> >           sched_ext_dead(prev);
> >           cgroup_task_dead(prev);
> >           put_task_stack(prev);
> >           ...
> >           put_task_struct_rcu_user(prev);
> >       }
> > 
> >  And sched_ext_dead() in kernel/sched/ext.c:
> > 
> >   scoped_guard(raw_spinlock_irqsave, &scx_tasks_lock) {
> >       list_del_init(&p->scx.tasks_node);
> >       ...
> >   }
> > 
> > Now on the sched_ext iter side:
> > 
> >   scx_task_iter_start();                     /* takes scx_tasks_lock */
> >   while ((p = scx_task_iter_next_locked()))
> >       if (!tryget_task_struct(p))            /* still under scx_tasks_lock */
> >          ...
> > 
> > So, the locking gives us the invariant: while the iter holds scx_tasks_lock and
> > observes p on the list, sched_ext_dead(p) cannot have completed.
> 
> Correct my if I'm wrong, but this sounds like you don't need the tryget
> variant. The 'users' counter is guaranteed be non-zero for one grace
> period after put_task_struct_rcu_user(prev).

Correct, I think we can just get rid of tryget and use get_task_struct().
I'll run some stress tests with this change.

-Andrea

