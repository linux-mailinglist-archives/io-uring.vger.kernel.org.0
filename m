Return-Path: <io-uring+bounces-13254-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DGIOTKg/WmwgQAAu9opvQ
	(envelope-from <io-uring+bounces-13254-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 10:34:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA1F4F3C32
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 10:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F0DDC3015D0F
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2026 08:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE71F38551A;
	Fri,  8 May 2026 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b="g5sNOCqR"
X-Original-To: io-uring@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012027.outbound.protection.outlook.com [40.107.75.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E14377558;
	Fri,  8 May 2026 08:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778229295; cv=fail; b=jiOOUmC36bKkU0IEsV4mFkDt05Fek6SE2Z7lH9K34jyHOQ0vnNfK5lkJzBMikXDv7pZT57gMF/nrUB5iMvg9FW2e/QnmMzkQ55Kq9sKYcawcmoKReK+3g2rgQMKnlhuqKBTAJZoJ3W8Ew1dT4i60w2ypmnS5H0PxMeX3qtw5V4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778229295; c=relaxed/simple;
	bh=oslorlyLm9nqrtMCQWrizQiwTf1z3mDAYmio8Nedyw8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RCL8TdkOB/sNZ+MXFqHKKkbMKhf4HZ+5cYRKAwA6FQKr1tV2vmj3T8QRZUWnsJjDi5fuB3irZ2IG1JZ2eeJGTxE+YpyZRVC26AQQlVNTOgCe5ykwJT3+KPxlQoeHLDQcQj4zFgXnOGpHDbY6O45jRN3AqETnPFwKjZv8Fz/azB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg; spf=pass smtp.mailfrom=ntu.edu.sg; dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b=g5sNOCqR; arc=fail smtp.client-ip=40.107.75.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntu.edu.sg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNg0vnj0LIX9PLNj82weenhUPJu0qtOoGbjqodGbEvwTYD2u52l51Xy6PmDZ8tnKWOO08qCAmkZrvLJYtFXZVM1dwTioWdLCCOELmwAB/gAjLLsdKkpHLobr5kwwTJjNBwU048cKkGlGC+6San3xwV5+1Xc1Z+TkHQCZ6ZP0G/hjKMhefpkLIy0lQqe22Zm42TC493W4oCzkvlJEKwf5Qd1GPpxiXmzBXnnxyH3KeC98tQ2/2ivqq/r/H4KPaDFAGV0CtjXVFOfELv4ICA6Y1tpde9OOf4S8EI0oOF6jdHZwcZxG26wonwUFKDRMTYNlPokJYowFUuZO1IfQ+eBpPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJPdUfl0ZY3ZAQb5uT0s9/ezf4hy7uYiqYQU82oUf70=;
 b=tnEMoUIsKPn7DWEG0lRez6wBL6/IQEQjO5vlE4ZSkjzhKQrs1+ym6EFXgLxKyKH1bj7zpAhd6Ey+grrXrb8O+deBFdvd94fo9dIJZqA1NLQtsapOV5hhyAmMqmRzn2ziIsU/cUJObs/GEfYAoa2u8dr2B9vpyr49YU5dAQ32a5AJDLj0xHvWoa3MorixTQqw1SaXmgIPMAzZaw7DTuabC3iFD43ACyLB2FCeIYyS8TP7Dp0ePiQPwUIKCXQ4IbuwGvSesOX2mTwmD3tbCNqWqRcPIP8dLFktr36gZIeboTdtDwE8BgFJPiO5RhsUTvERFwsZb8A6xr+lGzJ1dJIBug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ntu.edu.sg; dmarc=pass action=none header.from=ntu.edu.sg;
 dkim=pass header.d=ntu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJPdUfl0ZY3ZAQb5uT0s9/ezf4hy7uYiqYQU82oUf70=;
 b=g5sNOCqR9WdOmj0QZdkAA3pmwNkLRT/eqWw6ur9FkpvqCk+TvdZUv6F9LozDGiKQ7wl1we02HIU3zftSmKy6AyH94MNhrz2hP+eeul2qQHLUh/vEn/A6l8PG+4wyav/xZyxTIkqlBDjcTGmgBcjRGu+Oilek/2W2P0teC9pWsVdvpWFDSJi6+AujMlcb/qqJcpcAAnldfKopCCa/xbTpFC28yYVJjM83puF8XljVITkRDpi7cUiThVgaJGOFEr1pU7i2abGTYDjcXAVNJGrFwNx6O0kOvq5pVPXQAlo/gljBb01iEjXn31GDy9ky5JHMyj02bPfsvIieESoOrjmoNg==
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 (2603:1096:405:a2::6) by TYZPR01MB5374.apcprd01.prod.exchangelabs.com
 (2603:1096:400:331::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 08:34:47 +0000
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743]) by TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743%4]) with mapi id 15.20.9891.016; Fri, 8 May 2026
 08:34:47 +0000
From: Xie Maoyi <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question: io_uring SQPOLL fdinfo prints host PID across pid_ns?
Thread-Topic: Question: io_uring SQPOLL fdinfo prints host PID across pid_ns?
Thread-Index: AQHc3sTtsXa7mU7NMUSCu1NgqnaA/A==
Date: Fri, 8 May 2026 08:34:47 +0000
Message-ID:
 <TYZPR01MB6758E1C56BE8616027964BE8DC3D2@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ntu.edu.sg;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR01MB6758:EE_|TYZPR01MB5374:EE_
x-ms-office365-filtering-correlation-id: bc442437-7cfa-4d3d-d1f3-08deacdca98c
x-o365: NTU-OFF365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|786006|376014|366016|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info:
 4zwJXbUTiV+JgibMrPabOjsg+9kJT2xuNW1cYIZSJyo/Q8ttG/hODGUE+GvIa6UXbFm6zLpWIM4vjgr3AL3dcF5g94ar5e7jYOhVduIjUqCXqtbjpUqlMDpnxBN1Aho6VXYcz1zCmU76utr0fhI86QvriQm6LDZ0cCgic3ROReKAYn6d1bVIrojTmjQeDZidW1H81lyhl9+LmrRKAKFwl5DrxyJvbQbmdHJALO7BEIfrV3JQ64GYcvb9waZmtzCZovElCSX3Geg7CVnK4iNlsmYH2ObmRG3UyCvax418D1mtNHLfvs1Ack88Mx0eJoFvYXwnVuxjCTvCLKDHAEUtmhT+rFRuU1AXt5P2Nhc9Zcjar+ftAz85iXOsL1VkPDWqJ0yigD+vjm+307f/L6SKa6jIvRIBAiHdpJNbgPFM1f3IFu3T7OrAZYEGQRoYreUK+mCDWENzJQkQ9Qy6ZpyfVv/OCPUjUufBrdHk+R27bTnHFt4ACh/jxjd3eyZ5aVe3TwQn5BeKxiWi5Q6TpfAJnj/eEYr4FJrPcgIE4xq6PLhAaozRDl8nKPN2YE10UCaFUQVbAc0ug6oQR6pkwrsRwxeoBufugfCRVrQDFNFYSZk7uRUifdADkBzESORHI83c/EyUoks7zIJG5oBy+iBCMtiILW0udFEiF9GSH7KM9z+NsBMDOqnwICGouZMDPtpDAKKJK/CV6ejVL6UdbsClytI7ADBO5KyY4VfxXgPZZniARWdUCq96qhIR5BnIYR5t
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR01MB6758.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(786006)(376014)(366016)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?2qRx9qOAfw4CLGnQ8HQu8PysqTWkasOyUpTswkvUQ/SWWf7BGR29Pkb+n5?=
 =?iso-8859-1?Q?D/a/uuk4nNjnOOb8zxAuvU4vbIzEid0Xyw7j7FbKgB3qcuuqmFxV5u+yvh?=
 =?iso-8859-1?Q?se1ICq8L3DFWn3RrUve2pkrWzLLmWJdeLfTlN8+8JmtWWNmadEu+s7GLDJ?=
 =?iso-8859-1?Q?eYqR34sp5R1VHr1TBMiGIJ+omwDQqrn14iuwDDUavKMGVs0WxiwdrobG5W?=
 =?iso-8859-1?Q?+XuFZWdpNyXCy92FdytIIHCRbIyhlAdXalJYzpNEma7/Pb/NELnDNhfpfT?=
 =?iso-8859-1?Q?lx2oqcAi4MR1BWCt9zNraHLGzEknNFSME0EIOWy/6YNsCAsyWjD4E+Gz4T?=
 =?iso-8859-1?Q?235ekIl3eeb2xglJYEMACqGzjZrT2jwetq4SWFmnmWNEZ02j/eqaMlzFiP?=
 =?iso-8859-1?Q?fE7svUIDOQOnyaCr1MGbJXzG03U0celd7hL3SoPuXKCqQ/ZseQYjtHMxNM?=
 =?iso-8859-1?Q?2b/ntgZQ3x2ikFIV7rEIv5jecIDiexakVqGqY+LwOR816KYB+NXIW3BWdn?=
 =?iso-8859-1?Q?01y2EFXj0gLB3ZM6KE9iD7kF+JxmZQhBU24aFqEaoMt70a7utlrtYC+IBk?=
 =?iso-8859-1?Q?0lbZumu2/sVBlZTYAh3fIT3oTIEoffQyIdLEeBMIHv+Fqf156WOTpVRmi/?=
 =?iso-8859-1?Q?f/RQwadU3vtHlvGN55gE7MLWh1q4TFPFeleo3wT73qyVjoNUVaQcBzK78v?=
 =?iso-8859-1?Q?+J9BfymnK+khr6af3X1c6i6PzpgY45h2gJTq/72Xggqx+5UPaex/exKJrj?=
 =?iso-8859-1?Q?8yj9flmAHslP4ZkvxMpKJ69jYsmZGjusAv/zjN/bQJ88xkDo39+tUgHtW4?=
 =?iso-8859-1?Q?yr8KPhf64DIgQQCHG4b9CwK2uo0huDBTLhxTarCh3AQAXSpZTomWQY14/D?=
 =?iso-8859-1?Q?DnytqUNHIvRjexhkik8QYTBoamRwZb5evsCr4I0iPtIp4wVa9b9v8TiJuQ?=
 =?iso-8859-1?Q?QkrYzdWlVktGfLb1o++jRWSr9c5jSwAu4V+L1nxsc5OgDWzNWjJdpEgquj?=
 =?iso-8859-1?Q?qBlGz4jjWG76MnnrdgHBU8e7gF/xjJm4xxCQBZM2vv7WkIS66Z5TW67qRC?=
 =?iso-8859-1?Q?lb8NkZfPRhyqOHVc8eYyL6dGf1M0goZAN+CM1NDmGZYlIBzgpTOR6JuA4s?=
 =?iso-8859-1?Q?vuW8yL/R+Th0EO75QSu31Y2bc3ccRWt9/muwgvkGLa5mb3YKcT4Cpf7XdF?=
 =?iso-8859-1?Q?LZKP2puMkNUXt7zKwLfsixP+4Ec13h4s1Ih3lvQcinrIbtIt48W8sxL23t?=
 =?iso-8859-1?Q?FNEyZboKGAeCRc5t9j5News0mPE0ICbRQIq8F7S8rW0yBnkvzEQwxzI05h?=
 =?iso-8859-1?Q?1Axo1a24c1DwUp5cthYd/JwzBz1p79PNBFafxrKGeDyUiFnceIWqxrRtPj?=
 =?iso-8859-1?Q?VwIqjYjQDzeYjH3ihePKu/9vlj1CqPsR4bWugXoLCTtMIGOvZL+G6VLTpg?=
 =?iso-8859-1?Q?hxrMhBfKt49UozMtrf6/4TbYp8IvsTTplsRqn3bxP8vNzxCKeDsZwIYOKP?=
 =?iso-8859-1?Q?4AQU7vz4HHvwmyqpms0mA0kzFn8+ULHKgXC2e34e+VYkYGDL2MFmcByPI6?=
 =?iso-8859-1?Q?zrs1A5EiRKJesxlvaDdIG5c8Uyo8Lu72h2lGRuRZ+K0MCX3d7R/+0sSfM+?=
 =?iso-8859-1?Q?qyBTQg0guGfuliduadlArjjTuhGpimMHNv5DXyCcV/PT0+cNvftGVE2kZ5?=
 =?iso-8859-1?Q?UOl6KUCZWlX0FtVynUUxgitSRIxt4ncDGqv3xNpaEV3nN0NyCiwy+q6z4m?=
 =?iso-8859-1?Q?WD3euhK9aJjIOoFa3XBLwTsIvvP9FWxN8PBvub9C92qkgjeEibzLhdNdeS?=
 =?iso-8859-1?Q?t1APCKE0wK7qABW5+E8tURpHpiN8avg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ntu.edu.sg
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR01MB6758.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc442437-7cfa-4d3d-d1f3-08deacdca98c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2026 08:34:47.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ce9348-be2a-462b-8fc0-e1765a9b204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o1byi/TRruz2DdAgSair9D1tJSTPBdmAreuFceotL6oaRzphHdHjL/KlpjFnY9jFmJDfxTVUwY1Cno20h5q6eUTfmQDHygX4ZEfiGCKnYeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5374
X-Rspamd-Queue-Id: 0AA1F4F3C32
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ntu.edu.sg,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ntu.edu.sg:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13254-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyi.xie@ntu.edu.sg,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ntu.edu.sg:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ntu.edu.sg:dkim,TYZPR01MB6758.apcprd01.prod.exchangelabs.com:mid]
X-Rspamd-Action: no action

Hi Jens, Pavel,

While testing io_uring with the SQPOLL setup flag from inside an
unprivileged user_ns + pid_ns, I noticed that
/proc/<pid>/fdinfo/<ring> prints the SQPOLL kthread's host
(init_pid_ns) PID rather than the kthread's PID as seen from the
caller's pid_ns. I'm not sure whether this is intended behaviour
or a bug worth fixing, and would appreciate your view before
sending a patch.

Reproduction (KASAN, mainline 7.0): a process unshares CLONE_NEWUSER
| CLONE_NEWPID | CLONE_NEWNS, mounts a private /proc, and a
grandchild (PID 1 in the new pid_ns) opens an io_uring ring with
IORING_SETUP_SQPOLL. Inside the new pid_ns:

  /proc/self/task contains {1, 2}     # SQPOLL kthread is PID 2
  /proc/self/fdinfo/<ring>:
    SqThread:  356                    # init_pid_ns view (host PID)

After applying a candidate fix that translates sq->task_pid
through task_pid_nr_ns() against the inode's pid_ns (mirroring
pidfd_show_fdinfo() in kernel/pid.c), the same PoC prints:

  SqThread:  2                        # caller's pid_ns view

Is this expected behaviour, or worth fixing? If a fix would be
welcome, I have a 2+/1- patch in io_uring/fdinfo.c that's
checkpatch-clean and verified pre/post on a KASAN VM. Happy to
send the patch and the full PoC if that's useful.

Thanks,
Maoyi
________________________________

CONFIDENTIALITY: This email is intended solely for the person(s) named and =
may be confidential and/or privileged. If you are not the intended recipien=
t, please delete it, notify us and do not copy, use, or disclose its conten=
ts.
Towards a sustainable earth: Print only when necessary. Thank you.

