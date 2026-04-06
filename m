Return-Path: <io-uring+bounces-12971-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOvMAk7p02n/ngcAu9opvQ
	(envelope-from <io-uring+bounces-12971-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 19:11:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBB03A5994
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 19:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 145343007AFE
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2026 17:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C89334C0D;
	Mon,  6 Apr 2026 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=warwick.ac.uk header.i=@warwick.ac.uk header.b="QvfDUWsb"
X-Original-To: io-uring@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021072.outbound.protection.outlook.com [52.101.70.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E091C321445
	for <io-uring@vger.kernel.org>; Mon,  6 Apr 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775495495; cv=fail; b=duTmzto7L0prWWL+0ig0rgzP3+Tm7B8YMETopJE2fE9bPf+St1rNd+Xz61sHwEk+N+kSFyKW64+mRv7iiGNPCA6RpzMwdRnISy5xVwSg5M0anNFMUpN0qcfZDA+C2rE5/ldlcT6PvyLY/efuNYQQIVUyOY41KqLbgB/zn7Fd1/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775495495; c=relaxed/simple;
	bh=p4HUzlqh+BmXOljLX7rZbkhfIzb/DN1vo//imYc57Fw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O0+Zv0+L5UeuN6lIJYdLgoO5JEgA52kPccU/Cwwjo+bUAbcDvb/664e8NChVgr3yTORtO+v1/FQBhqeuQSOi4Sii1NHVQh4EwSyHyfcPPR/UJt4YVWiX/m0qzC3WszPaFUQa452a5drUjLd4E+8NXKLqAnSbZ0YZHwRlnTqymo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=warwick.ac.uk; spf=pass smtp.mailfrom=warwick.ac.uk; dkim=pass (2048-bit key) header.d=warwick.ac.uk header.i=@warwick.ac.uk header.b=QvfDUWsb; arc=fail smtp.client-ip=52.101.70.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=warwick.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=warwick.ac.uk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BzQl2PvRx5I1bNHOzjBTJCJUh7wFtPVdUd8BBiDjl5vvrQe9kWKPvWtr+wcP28KKYnwoYagJITuJdbw/H3z90/Q8ncyVdUxs7+jwlS/ipkdQtqBTEc0magJ8y9HoxzRUw8V3DfBRrKRrCWz6CnrL/aM4HyCHt7Vg22cood47XhJoCmrpDrKXSpSCUu4y0N/gXVRLYPNV9srYCSulUB5+eRt03mkgAJ5cBhJwLpZMv1xi8q5R6WJ+VSCy+aPz7SGboHBpDtKHirDvyiEKRchGxMg5u6rxIcJZqTBZt0LLGadQIGbuvAg4xv+TpHMAdW0J+hKDqbPhyFPKCiMVP9FRsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4HUzlqh+BmXOljLX7rZbkhfIzb/DN1vo//imYc57Fw=;
 b=sweSEAr0+xNN4pz3NYn63OKNlNmANY3pOmp6Y4anHaUphtTAErwpCbMwONIQCvcbJwgHYkJM231YicSuPAFiXzajs3bec7GPdG7Apoc77SBS9fj4vSjlStfoU02CpPaiXwBm1ekrJM9mEv0bywMt506VCGDyCXujmX9qwPaN/joZpUSCXuOQd0Wl8BWiqCzyIiYRXjvCCppbeWbK6jLF+G7Tp1Jbf7GwP2qGSBA7NN9LmZuwsZbzGYPgHjYEODyQwnb33r2t9GNK2U/qe3wPwxU7T8ZwnrvQyxYSlfRggJxD3w5XTCEpy/WB9oo1EJEIRTcGWvCZ+MV6wBhsymKUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=warwick.ac.uk; dmarc=pass action=none
 header.from=warwick.ac.uk; dkim=pass header.d=warwick.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=warwick.ac.uk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4HUzlqh+BmXOljLX7rZbkhfIzb/DN1vo//imYc57Fw=;
 b=QvfDUWsb6YZbK38nF6+vfWfZmzD9delqSCBR790MHYPWH7qitZqrSnp25Mz4nJ52jFm3WJoIIQRHKcP2RpnVFF1p9TkckUycBPNV6MH29NR/tqN6/X58YxIaVWFD1z5BuZyYkot8/SlJMfkuBamRSLVGBGh2/gvXN0+MRYa6OMZAnYF7YUzfhZYQ7HJ69EPdxMXMX9m2DMSVD3kIdZYZMNwIHmx4HfrkEpPQtxb/ucG1yYOiQahDDwdVyAgUE9JonxARAikgoVuxq089/H9nXx4DMcXpRZ907V0ije6zMQ8v1z4ptJ9pGQuYR0TG56rrumTFqxsygmu/y4/Rz+u8JQ==
Received: from VE1PR01MB12289.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:6fc::16) by PA1PPF7C5E2458F.eurprd01.prod.exchangelabs.com
 (2603:10a6:108:1::29f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Mon, 6 Apr
 2026 17:11:27 +0000
Received: from VE1PR01MB12289.eurprd01.prod.exchangelabs.com
 ([fe80::2701:893f:f223:7d1a]) by
 VE1PR01MB12289.eurprd01.prod.exchangelabs.com ([fe80::2701:893f:f223:7d1a%5])
 with mapi id 15.20.9745.027; Mon, 6 Apr 2026 17:11:27 +0000
From: "TRYNER, BERTIE (UG)" <Bertie.Tryner@warwick.ac.uk>
To: Jens Axboe <axboe@kernel.dk>, Bertie Tryner <bertietryner@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC: "asml.silence@gmail.com" <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure in
 zcrx_export()
Thread-Topic: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure in
 zcrx_export()
Thread-Index: AQHcxVdrqr+x3p/HqkmO5XfjxUnGULXSN8iAgAALpSGAAAJDIA==
Date: Mon, 6 Apr 2026 17:11:27 +0000
Message-ID:
 <VE1PR01MB1228938F1F3011030EAA6EEE1B15DA@VE1PR01MB12289.eurprd01.prod.exchangelabs.com>
References: <20260405235330.49287-1-Bertie.Tryner@warwick.ac.uk>
 <7e4d8e97-850a-40e7-94e8-e82dd56c0386@kernel.dk>
 <VE1PR01MB12289E1FFAD5D850361B58232B15DA@VE1PR01MB12289.eurprd01.prod.exchangelabs.com>
In-Reply-To:
 <VE1PR01MB12289E1FFAD5D850361B58232B15DA@VE1PR01MB12289.eurprd01.prod.exchangelabs.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=warwick.ac.uk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR01MB12289:EE_|PA1PPF7C5E2458F:EE_
x-ms-office365-filtering-correlation-id: 6100d20f-9cd2-462f-1317-08de93ff8a13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|786006|366016|1800799024|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 LMj/adTZrUzfg5ujeeUOcZdH+gKZcnbNcHJ7+ZpIAqF76ZN3XDlN/HR6c+Dns+LwpTLdff0Q2SEhYgqj23ZJ7sKyPejSi+pCWupN0IbK8xhiKHnOseX6k7stp5i8Bwyd8jgVrrYOQTiBDgHdpoEuNhsR7zvO3IUsE1REViPqBkunh10TnWJPm+mdzgS5Htpd8fSc62URgffY2PZayYowjFnBoSsLF4ryl0YU49V36rRlb/qN16nWIKI3qHLoOj8zkdXfnnaaURQI0qRAwAF5wXs5LTeqN2uRGR3DCsP6k+ZKYNXHW2l+YnKt9t+a30gCsRETEt+WyTdOGF+eTAImkx+tYaM9rAJUXlMQlMcvgqiAEAFMARid89rHDiNPmCHQt7eIdqOp2tzgvrFxXPv3re1ibn4iR0gT7jzbTNkCCAh1NyoeOitlhTdoc0a5Yu43Va5Dw3gsXteiPfsCVMj9NSRWqFzTuLPzWwC5Ikq2KxoZkF5rVKgpY6B19XUj9gMHvyTenOiWTBCL9uXoSmKqmrwxBM9vWjpz9jxLAhtlKo2FqlE9qC9Tkrxf5jU7F2wqFhpUHr4+SJsccRUJkbaomSzwctUpSuXRhe0lYaCvsOzNN9mBUCKb16SV1otnTYuiwiloKD47YsPIkNCE7gjmb7kQZZCB5JY4o6aeTnHlMWZ3Xq4gl/7zpV/XIkL8JJ/Elb3wZXNoZKktzZHt/ikOh5mwrWil3KQ3a4RIujghLWHe12tkFD64J0gbZZkZatcAjdAnodSQi/J2vxtr1Hcbt5WWFKV4gV3KkcYQYjMbtdM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR01MB12289.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(786006)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dLx6wodTqkx4msGEzsDYQhTm3T81e0N9yLvdeCVN4snnKSTKeau72zWtrF?=
 =?iso-8859-1?Q?Xd95MrVx0ac4//g6fLVhbSeFHkEZaM+AgfY5ipONFJmrYcoz3JGgX9jGQq?=
 =?iso-8859-1?Q?WNy5R18PYRVcpcyw6P2gy8agH99PCyzZPXT9TgubaIZuhOVd0yI1Vj/oAC?=
 =?iso-8859-1?Q?+VxZf4KudMiEv3jgOSxO7EwDWxRfCGzq3UO+QCYAt7s04wU2QO8APBKw50?=
 =?iso-8859-1?Q?sC55NmWmicuPomJU2aZ7qOw1fcJO8dgfiI33RKYpeo4vKb07m/Vl7nn2FE?=
 =?iso-8859-1?Q?vkNWowWw/kgyMjjcQ8KD/uGzWVgGHGjGwgy283Hqlt8PcaBNVWs92DfvQk?=
 =?iso-8859-1?Q?lHa4dZQ5yAZybwcOL6v3/jVTUS+2iI4/uGfG4yKNFIj8B7LyhG4EC9qnPl?=
 =?iso-8859-1?Q?MyIC8lccEqxyI27njy8CdbJA/gAPc0L5V12SylQT9vGCpv2CNHbeA0jZ8x?=
 =?iso-8859-1?Q?yDpmbhiHnqxw/fSEMewlwf0tKFCW29WNvbe05Hicwf3gM0D3/CMAwrYt+J?=
 =?iso-8859-1?Q?NcZALJZ5exdtP3rHYCynlS+XMIiAmQNaonIeYCxQx5G/eA4JLyKgzeeg6R?=
 =?iso-8859-1?Q?KQYi3+mdPYkM/E5c6PG7OkaiE446UBn/SoQQkOZB6wUhWnTIh2kLMOicZg?=
 =?iso-8859-1?Q?2OwG/ivuq0aqVVGuKJwZozrXlzSQib9/CmuOXx8y6vUicAZXgtqRKX0ou4?=
 =?iso-8859-1?Q?2l+L19yY+oENkFr2zGAFuV9v4MtBwgq+mVwiEjJunmz+P5GXnKyRjYwGgt?=
 =?iso-8859-1?Q?ri5Jem/cUrht8bYnFO5sm8H0q3flFR/gXB47Vh9EyvLQvX+Sh9slBjfHjj?=
 =?iso-8859-1?Q?0WxtfA9TSOkTvDotEm3Oy67OICbL95csONGpLRqT35E4VO3ewMQp8zHnlk?=
 =?iso-8859-1?Q?NCCNsMgANT3unB6Ci6++Sb0sfTqcdo6S1fvm0jzFX+E4lOscVeGZDk25WJ?=
 =?iso-8859-1?Q?9GTTfqU0RfFwSzwgEmZ8tPBjbEVMp7aWydi4ZyjuMDJICfKO7H/sS6R/Kv?=
 =?iso-8859-1?Q?IIk0bzLWaur3hgP4mfDPhK+iR2HuBeoaiQDqyhlYLwTyHNU1v+6bA/9AC8?=
 =?iso-8859-1?Q?tprsiduZt8ksDry2jv4mHSWCKmNoqqpK6eeVJbJfFRck2VluaNg2Y86hHM?=
 =?iso-8859-1?Q?p0tf+fdHckBu2ZNjN/NH/PbpnVn5yg5S0Kmrwequ4jgKMX0O/ROQW6NLN3?=
 =?iso-8859-1?Q?dEJMygh9QRtFZBZLSnVaOCac33ifnMhiG4idu8WGekKsSEc1QVa/RU7TZp?=
 =?iso-8859-1?Q?PmxX9XQIKmngMPsgOUH3allZyNFaPRuZljokj56UhGUfVks9y197g1sGt6?=
 =?iso-8859-1?Q?A+TnWTl86xXnckACuQGHIZtIutsX/jGv9Z388oXr10q8HL9CTnTH2Z7U4e?=
 =?iso-8859-1?Q?1C8tp8hf8Tw33l+MRX5vB3NWj9618nYUFYyn6pUDAVl1sWh7uDfKs7sEor?=
 =?iso-8859-1?Q?UiWXJGjgkixeQhv5ZxvXLE1dCT/3LCiLYaSSvo+HAAOKz320QLy+pGvdDj?=
 =?iso-8859-1?Q?ghLIO+r9JLvgVHVEnicgP6ntSRLsndrVEJ71XnwxI5o8xwhIsgw+0zl9rC?=
 =?iso-8859-1?Q?wSsj0g40YgqZ3x9dMbhvJbsMIJs3iiM6CE7AFSNU4wCew2Z/P4zoT/oCoc?=
 =?iso-8859-1?Q?wMG1DljQ5rXHfkYIDDcbNO4NdteDl5QZJdZfpi+zJ9N5cj4WP0CN1VEuY4?=
 =?iso-8859-1?Q?R6PqlEgzviFfi4NPhqBTNnyoahY1GRSSOQr7uqF2+I5uG00oL+7NPrmdd+?=
 =?iso-8859-1?Q?gOIZC98WIM3sEUaj2Mq/Ksdhy5oHTaNdtplbsU4jXgXuRy38vsJO3pWPj7?=
 =?iso-8859-1?Q?zRPw+59SCQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: warwick.ac.uk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR01MB12289.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6100d20f-9cd2-462f-1317-08de93ff8a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2026 17:11:27.5083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 09bacfbd-47ef-4465-9265-3546f2eaf6bc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZJ1hAX52DCDxs6jA4qJOVmje2X1mPDqavsIGhUUGCtBtL5L6bZuXfH9u/skaFa7xcqKf3tDZlhMUqc5eVkBEwbjeSS7uQZTmMojN4RJuCr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PPF7C5E2458F
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[warwick.ac.uk,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[warwick.ac.uk:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12971-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Bertie.Tryner@warwick.ac.uk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[warwick.ac.uk:+];
	NEURAL_HAM(-0.00)[-0.996];
	REDIRECTOR_URL(0.00)[aka.ms];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: EBBB03A5994
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,=0A=
Apologies for the confusion. I'm a first-year student and still learning th=
e specific terminology and norms for these reports; I certainly didn't inte=
nd to be misleading. I've just sent over a V2 via git send-email that frame=
s this purely as a cleanup.=0A=
Thanks for the guidance!=0A=
Bertie=0A=
=0A=
________________________________________=0A=
From:=A0TRYNER, BERTIE (UG) <Bertie.Tryner@warwick.ac.uk>=0A=
Sent:=A006 April 2026 18:05=0A=
To:=A0Jens Axboe <axboe@kernel.dk>; Bertie Tryner <bertietryner@gmail.com>;=
 io-uring@vger.kernel.org <io-uring@vger.kernel.org>=0A=
Cc:=A0asml.silence@gmail.com <asml.silence@gmail.com>=0A=
Subject:=A0Re: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure =
in zcrx_export()=0A=
=A0=0A=
Hi Jens,=A0=0A=
=0A=
Apologies for the confusion. Didn't mean to make it sound like there was a =
security issue in the commit message. Ive just sent over a V2, I hope the a=
mended message is appropriate. Thanks alot!=0A=
=0A=
Bertie Tryner=0A=
________________________________________=0A=
From:=A0Jens Axboe <axboe@kernel.dk>=0A=
Sent:=A006 April 2026 17:20=0A=
To:=A0Bertie Tryner <bertietryner@gmail.com>; io-uring@vger.kernel.org <io-=
uring@vger.kernel.org>=0A=
Cc:=A0asml.silence@gmail.com <asml.silence@gmail.com>; TRYNER, BERTIE (UG) =
<Bertie.Tryner@warwick.ac.uk>=0A=
Subject:=A0Re: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure =
in zcrx_export()=0A=
=A0=0A=
[You don't often get email from axboe@kernel.dk. Learn why this is importan=
t at https://aka.ms/LearnAboutSenderIdentification=A0]=0A=
=0A=
On 4/5/26 5:53 PM, Bertie Tryner wrote:=0A=
> Currently, zcrx_export() allocates and discloses a file descriptor to=0A=
> userspace before the backing file is successfully created. If file=0A=
> creation fails, the fd is released back to the pool, but the number=0A=
> has already been written to the user-provided control structure.=0A=
>=0A=
> While this requires a misbehaving or racing userspace to trigger,=0A=
> it is better practice to ensure the file descriptor is only=0A=
> disclosed once the operation is guaranteed to succeed. This aligns=0A=
> the ZCRX export logic with the standard patterns used in the VFS=0A=
> layer and other fd-publishing paths.=0A=
=0A=
Like I explained earlier, there's no "race" here at all. The file is=0A=
never visible until fd_install() has been done. Any attempt to use the=0A=
fd before that happens will get a NULL file in the kernel, and the IO=0A=
operation failed.=0A=
=0A=
The operation clearly fails, and the error is returned to the=0A=
application. If the application is so buggy that it ignores that and=0A=
wants to use the 'fd' value, then it's just buggy. Simple as that, do=0A=
stupid things and win stupid prizes.=0A=
=0A=
As a cleanup, this is fine. But the commit message is horribly=0A=
(deliberately?) misleading and that should get fixed. I'll let Pavel=0A=
decide what to do with this change.=0A=
=0A=
--=0A=
Jens Axboe=

