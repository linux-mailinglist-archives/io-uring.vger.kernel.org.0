Return-Path: <io-uring+bounces-13214-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MLkEs1l92n6gwIAu9opvQ
	(envelope-from <io-uring+bounces-13214-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 17:12:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB314B62FA
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 17:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B14C30087AE
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 15:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6798B2C08D4;
	Sun,  3 May 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b="fLeHZ2yo"
X-Original-To: io-uring@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013049.outbound.protection.outlook.com [52.101.127.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9140DFA3;
	Sun,  3 May 2026 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777821130; cv=fail; b=GvM6nUZIFeG7OI0jvVlH96SznOsX+3wJ4u+hc15LjUgg2X2LKd0nl8FeEqXzVfyTx4q5EC19RoHcy6qZhS7HXeMMTTvkPr1rr2N2eETVHH6clqzj+EBnHKkLbwfjoX4a7DQ9XugcPkRA9ZfD9CADVO4yVJCP3lrapQZMt84Ts1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777821130; c=relaxed/simple;
	bh=XdNIg4DqtC9V+FkCw39ZvOYFBfHYwzG3aJSMWC61rmQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vGQc0wkxM7GSPg4RWQkAGpkKTbjwr76/r6sAgGzBtNyq1/F0eqapuzG8SeOXj731kU4QBbHd1649YLzHck9pNtdAayiZ+4YJ4W7E+fDgL/HZqKzG7IsEyrDZ3+u7RaGnLHry8/kJQgH/Zl8noBPduV2gK9LDzeAEQAE9QxQScOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg; spf=pass smtp.mailfrom=ntu.edu.sg; dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b=fLeHZ2yo; arc=fail smtp.client-ip=52.101.127.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntu.edu.sg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1sFopMwEaWBHRwLOomh1Vdt5INlB1imM8QyiUPYRDZP/WHTZ0P6uJ9VogE+2ii1A641bCaZH0M1pZmKysnTHPjizVg4geR7L39/I570KFA+FzObJt9UMpIEzwqhCGEmV4cXXh+haUJf/yLw29xIExeZSuSFCWssVTzwXLnWG2GSZymQlMkaID1fKgIL2XPSb3Y45D05YPSkVrskZSjQJwnLLsQNWaY8jTXq7WUFTqBdnaXA6eySlAQ3nrip6/sZPJ3spK/CLFICs9XwRYN6MFNEye0dn1dh+X7mUtFiCTUyLQKd8he98L7/dC7gqMDnabTB3DbyKk/ja4q/nvZb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXV/dl3R783LS5GcXvn1a0briDcVnB7RgKaxGDxUlgU=;
 b=SatDcQ8rTrjX/S84Q+wlZEbmB9kGrSm9D1zZ0GEVQTL4fhViLg4yNyoHdfCr/t9M3C/lQRzee53cqwrLcOWjUZajiiz2Uhe6WwHV/6ZNF2AbJ9fac8OIznJ5EMw0zOOEX3kodUBnGql9+zq6+b9cdYzj+06AK7gtHxyc7Aws2gRDxDFE3SNdWFbYue9IfgERRZzKhlK2Im4nUBqeEc5vIvR02P6npCgA2Niih9ubxmNiVsxK//+EpTDczMmrLMvGD9i2404j1BttE65qeymOu4PlLRwnz/i4nQi8HhZmyjLdJ1ceTkdK+I2EampA0DRqXN7jObh+wW3/KuLA66DkOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ntu.edu.sg; dmarc=pass action=none header.from=ntu.edu.sg;
 dkim=pass header.d=ntu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXV/dl3R783LS5GcXvn1a0briDcVnB7RgKaxGDxUlgU=;
 b=fLeHZ2yoilLrsBEamGLWCfV9mkmXGqpW5zqUwRYIPt3rJ98Shdi40MociBab5hpR2A6i+JTC5ma2FsEMi7jc6Wy/fhepXmCrFLXI7ffBNmAKrTbYE5gvHCqAfilYyk3nY32t6GFIMhDeBqe1nN+L+WNl4pj4CVast+7oGm2ZjhiNWHf+k7Z2BUCRkET2uiEfX5VP15mgIgo7E/zPMqb4khBFk34wqgwUm7cnldGmEaLy8ouCLGChV2ot9jga0k+3o+aMtWGW35p5hqVQQzJ+jYaQreWUSTWm9P1qqUtnlD5icgrsd154Hzc4364f6vvuTwdKYg8QUjW8eMwMWSNegA==
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 (2603:1096:405:a2::6) by SEZPR01MB5893.apcprd01.prod.exchangelabs.com
 (2603:1096:101:1ea::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Sun, 3 May
 2026 15:12:02 +0000
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743]) by TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743%6]) with mapi id 15.20.9870.022; Sun, 3 May 2026
 15:12:02 +0000
From: Xie Maoyi <maoyi.xie@ntu.edu.sg>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>
CC: Andrei Vagin <avagin@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Topic: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Index: AQHc2gC1O+evKeW+H0uOkX1nIKwMBrX6iDUAgAAZu8qAAca85w==
Date: Sun, 3 May 2026 15:12:02 +0000
Message-ID:
 <TYZPR01MB67581D3389689A4427E41E92DC302@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
References:
 <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
 <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
In-Reply-To:
 <TYZPR01MB6758466089A9CAADC5095F20DC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ntu.edu.sg;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR01MB6758:EE_|SEZPR01MB5893:EE_
x-ms-office365-filtering-correlation-id: e90350ac-a4c6-401b-d6d4-08dea926543e
x-o365: NTU-OFF365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|786006|1800799024|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 aHzLa0AmdAd/maPjjQzZzqsi9YSEC+vVkJJg18sXROeQMQ19m11OFikjxaBeJ+4l0w1IZRbDvnCoT524Y+2OiuBQHQ5NbrHd0iAQoibjLoe//AZNCfXn1vqC6GfySH8Cf9LXxsBup5AzOv6CGX7wGX1KaHee4l2bKjq7W3fqHVMTLHOfxqWMJlCrbKuE5ESZElRqNZwWCvIXbQ6Cp7f2c2Ll0aU1aYlAs19BcGC6Lh7r2Qo30SGCGj1AJgYNCPe4PQkEiH2l2sR8XniDw9S0F41tn6HGZ9URuWAYAQDSCtNAixxgIa8AKGF97fCvUd4nMWLinCWtkj0WoI7UWaDeEFJB1IQ4KzvAlyWajvwWli/HaFC/q8sc5lcv0fzg/STpO7maHn1tHVs9eTiJYuvMXyJThJdq3yKp+EMyq21tXLNnmftcyM7H4ngtxmnc1oAlVrq3A6/+L3gAO00dO2ksh7Bp58D1UCrx1wXZOsSQlw2OgD/A/QOqoGsSZDvZ+z5BQ/gRhqWL04HVBCtA7c0o9wewF1ceO3/m3Ze/bkvuLshLuVWFFCR3vnwJEWQjZOPDaFmGlyqGcJfCYgflIcLdipMT4+z0flc5DOVPzuoCcntT0nUArAyrkz548Fm05lrU9FJDVbGQUL6oqKrMptRBPGiVgNiaTatVAAmj7912V0JOQfLiNamcHXHZSe4FiMDa
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR01MB6758.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(786006)(1800799024)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?i+swb6FuyKl6dfaygIKl7wP97d9j1RDf6xXa4+XUFe8siAa2IE7c/1PPoQ?=
 =?iso-8859-1?Q?9IeMM1B9nqZwxqFGl95WcIaj0SXAnvjAEctoqPQcAseLVn29tdsBP5C4lW?=
 =?iso-8859-1?Q?DbohiCWFyiF+C+Lbq31zimxqoWFBG3GXLac2F4kONIzAGQjb//ZKbMf0kk?=
 =?iso-8859-1?Q?kCFP0IfFTEduHYU9siQtcjo0uZgl5u4bSux4ElgUPvBwxgrzuaJ3IVXJsi?=
 =?iso-8859-1?Q?Hn49Xy8/WmVwC/1yBACUtA7FtFt7pmhbyMAGAJWDOwL/YuWarCFzG0tKYw?=
 =?iso-8859-1?Q?VrE4lGVZpkBBmDk/NYOOtLJUwy7nixf/6E6aqkEVBOtJdrea6M3xYsMg+3?=
 =?iso-8859-1?Q?uG01HFGO6UObkJ7AevNAx4CdhClYl2OorFtd9E0hwG61YvUk2CmXzLx+C4?=
 =?iso-8859-1?Q?3YEhH/2OyD1uTy+itf95dcitb8PlYNls6zCulNFrFo+Aj4WDYZf3KjiqI7?=
 =?iso-8859-1?Q?65TBHHAKnmO91LP6edUFUewnJ1l0iscHJRiUzbfonev+PvVezCfVD3i2hD?=
 =?iso-8859-1?Q?MDw2618kPyLt4DPl3drBgoucVwTg0dE5J306qMvAeI3KC9XIDDZuYYqPzD?=
 =?iso-8859-1?Q?YEG54W25dkoy+HOvsON1rv7HyIB6IZEgWjL8yVWpcrLm1JuvJNieEDoomm?=
 =?iso-8859-1?Q?oviUgHlqCYwOJ7OC7kHJhGnyefSz1LprTggP9GNG9QIIJRsHu9ghwTUEJG?=
 =?iso-8859-1?Q?cCxqUhYVpLA2iUJPil0cPXq1jwKsc5IETkrB1ryUda18g69JLtWNZCekli?=
 =?iso-8859-1?Q?xq2TH6IO7tzrzlpSWHP6/Qn/pTTCbCMwzESi1PIwPdwVWJmW+jezFdTw2c?=
 =?iso-8859-1?Q?8NvGYvq0hRD+jiKoVP48YierXSqGbhvrSIIZUZFbWZf/WaRs/rsW6xuw8F?=
 =?iso-8859-1?Q?RtYMIFZEpekpECFQMALTWAMAKyDb23KIT3c97MEUwwsk8s6xwwzDpbj/QX?=
 =?iso-8859-1?Q?hxqPeO4iALjGiHSASuJElPMtjM0nU3eVHe/wRSMGfoA1dEAsoj6/tBh8Ax?=
 =?iso-8859-1?Q?TMbV2KVEtOzMv+ixXTE/21tJ1TLqtBGoW72bwW9ImeCiKHsj6J7kKlcvI/?=
 =?iso-8859-1?Q?XMZ30t+V1fGIL6Ug1ZgKLue1lN9qCW3auvwLRKu9wKOwc7Yo9YZM1CKnOz?=
 =?iso-8859-1?Q?lrkyA4NagdUAB2XhHv7lyZPGtIM40shiT3Ux5cN8kl7Um6dPzQ5z8lJAqe?=
 =?iso-8859-1?Q?GGMh3NM+Mnjwn0ZRUo8elq6P737YOMF5cPXytUGkSwpWjDRsq8y5lru0sZ?=
 =?iso-8859-1?Q?ahDlDPB5Q7+uFKRHLlTBV5h+NnRz5E7M9paATAiQUJpEyT86DeY4MCMqmw?=
 =?iso-8859-1?Q?VEL+6ZWRR/e0pG7Jhckp543QDikII9JfqNJxOyNPBZ3xYMyl5RvyhwkWVB?=
 =?iso-8859-1?Q?h85G4B9wWGrvqru5uW3ie1Vzv7GKIETlyhTmWnOGK29TSLT1hz+jjdliCd?=
 =?iso-8859-1?Q?m45lv6v/lObqSvp3fjYS00cFAbv6/8ul8jE/nWE4fud9MM40i80D8cSYLw?=
 =?iso-8859-1?Q?xflBgkz4pw5BKWWgRhV5zeSn1BpAZIQzYwep69hPDgTaV5kbyDzRYQblI5?=
 =?iso-8859-1?Q?cI2AUjNoLdkozF9pwo+s2x1KfY4xtNjUgFwof1o97PtwQbH0hUuske/NPV?=
 =?iso-8859-1?Q?cCReBcW1yxmkFeLByFybOGM3xYuspaQRcvZIqkOoxpFrPV8BqhGHIncbJF?=
 =?iso-8859-1?Q?OifsF1fa+XXXOEWvGop4l0vRoSr+VDtkHIm/iNnrKxErmOxSv9DqybR68F?=
 =?iso-8859-1?Q?yyL0/K9jj1B8rjcJluwuxUiTzkkhMT1DuizfTy70apQaKEx6EMLdO/eX1h?=
 =?iso-8859-1?Q?64mvFAYYfwg7fwWMk6rg3w0eJ8Tw3Ws=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e90350ac-a4c6-401b-d6d4-08dea926543e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2026 15:12:02.0292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ce9348-be2a-462b-8fc0-e1765a9b204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MTWy4qhy6THcLYcvtSjslmFC8eLllR9xFNOWxSZiikKHmVQHiKRCQTURbAykAVTEwMD0YYSloTOaJBqZhiN2c9BUVnaEv4YjIfUY9GHTViA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB5893
X-Rspamd-Queue-Id: 4FB314B62FA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ntu.edu.sg,quarantine];
	R_DKIM_ALLOW(-0.20)[ntu.edu.sg:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13214-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyi.xie@ntu.edu.sg,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ntu.edu.sg:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,TYZPR01MB6758.apcprd01.prod.exchangelabs.com:mid,ntu.edu.sg:dkim]

On <5/2/26>, Maoyi Xie wrote (correcting my own earlier reply):
> Under SQPOLL, the parse path runs in the SQPOLL kernel thread. That threa=
d is in the initial time namespace. So timens_ktime_to_host() through "curr=
ent" silently misses the offset for SQPOLL submitters.

Apologies, that paragraph in my previous reply was wrong. I have tested it.

Vanilla v7.0, SQPOLL ring inside a fresh CLONE_NEWTIME with a -10s monotoni=
c offset, ABS deadline =3D now + 1s:

    [child] SQPOLL TIMEOUT_ABS elapsed=3D1 ms (bug fires immediately)

Same kernel with your conversion logic applied:

    [child] SQPOLL TIMEOUT_ABS elapsed=3D1000 ms (offset honoured)

The reason is in create_io_thread(). It is called with CLONE_THREAD and no =
CLONE_NEW* flag. copy_namespaces() therefore shares the submitter's nsproxy=
 by reference rather than allocating a fresh one. Inside the SQPOLL kthread=
 current->nsproxy->time_ns is the submitter's time_ns. timens_ktime_to_host=
() resolves correctly. So the SQPOLL follow-up I floated is unnecessary, yo=
ur draft covers both paths.

While verifying SQPOLL, I also noticed io_uring/wait.c around lines 230-234=
. The IORING_ENTER_ABS_TIMER path on io_uring_enter() parses ext_arg->ts in=
line rather than going through io_parse_user_time, so it does not pick up y=
our fix. Same shape of bug, separate code path. PoC on vanilla shows elapse=
d =3D 1 ms, patched shows ~1000 ms. I can send the small follow-up patch fo=
r that path as a separate thread once your IORING_OP_TIMEOUT side has lande=
d, or fold it into the same series. Whichever you prefer.

Best regards,
Maoyi
Nanyang Technological University
https://maoyixie.com/
________________________________

CONFIDENTIALITY: This email is intended solely for the person(s) named and =
may be confidential and/or privileged. If you are not the intended recipien=
t, please delete it, notify us and do not copy, use, or disclose its conten=
ts.
Towards a sustainable earth: Print only when necessary. Thank you.

