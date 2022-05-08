Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCB351EEB6
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiEHPgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiEHPgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:36:06 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2041.outbound.protection.outlook.com [40.92.107.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0466711A3E
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag0rBveCp4Arzaag5J2zxqKABtOSSLkddYe/WzpSQcUGCVO+l0lKGbLocEZit3aY7Kdcg9hOrk33axog6OIWgpO2oZSrm4uqKhJm5+4mplkU9ptuqI0yHu2cw7+0ZwaHH31gvrkRwHg9AvjgI9cwOZu/kjTuvqKXewMeM8JRsIKAaEOn7Xpo9agKvtnSZuAYTVTN1+kbJhWaZ9gKGR7F3Xcus3y4By64xJoX2xH/88NcQrfjJW4o1Epo1m3+C4hSbad7VhfPoYGeo2wwh5VkpCqZ+u3lrxR5T27YHuIxozdfWR5YMfT/sTrTT3r+gBflp+U5gazxcZwWJF5PIDitww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOaqArMdGRyZW/1ywD4JdWT0Wwrs5sbDHba7b6tlX2Q=;
 b=eCXHxEIBwnc0DeDohaPkKmnXIiRlbkiTsOdmWiUWDE8iGMYmF2DieG1x4Aey49MmeNsN3nvGpFTJZ3VzDwoFnOUjT3DbSDxLBFKrkNhT/bclEkQnIqFCwgtBu6jh9xTiQXfUdBJpDdX9rfTHR7fUL4CAXJ4x60NuRppj8Pl3iDUYshNRRgA1R5VQPSDzjTxXCdx77sd/NVMe4vP0jyiArwTwNvpcT2iNH5lOxCFUY/41ag4XCbJHvYeaw6KVksTUrcPJgk+97CXhDsaSLROsQG7e8g+EcL4TANsvWS5TrqyD6pGLOWCuBGim5Oieg6O9hdF+QwpeYsM+8OcBaenAPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOaqArMdGRyZW/1ywD4JdWT0Wwrs5sbDHba7b6tlX2Q=;
 b=Klo3iwKtGzS/n1bNgEivw7LepSUnP8UIaEH19tH2OllF0G9dpj+eeScy5s6Z77hrEcBvsg1VVXZZ0EWsUoOV+D4NTP4jifFc3mjV8URKQdUIVeSWV48DlYQnwLjJtx5JEUym1jjcsFD1nqhS/XmPGB7FBvbgo7x3fYgGqlfOXlLJcXPd+hTvu73paaFYrvSzyRfwui7o/hwfojVLRkEqpreUrLNPSWFwRbiQokERnZEfi5kutxWJjp357b4MC1ODKqmrf1ytEMqmmDh2X1Lb78Bdy6nC/7Nx6poG51RkzmLBx1BZbYJY14CEddffPkyd+5y6vnwrtf1Ycl53KS6p4Q==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by TY0PR0101MB4360.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:32:12 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:32:12 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 RESEND 0/4] fast poll multishot mode
Date:   Sun,  8 May 2022 23:31:59 +0800
Message-ID: <SG2PR01MB2411F8027141F3E6ED895F7DFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [AqFh4Y1JA4bj/DE3vnbts7iHxl2e8Rw0]
X-ClientProxiedBy: HK2PR04CA0051.apcprd04.prod.outlook.com
 (2603:1096:202:14::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153203.5544-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90e9a8f4-7f78-415c-c874-08da3107ec1b
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4360:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y29pp8nKfluQBb2CSlGXSRYXRT287F13zSQIf7uHZPYeJLqlYnp78DzSo7chbb2DLCZS7c47FSNV/p03v7ytUtNBkI5tSYYxLCGPoeipizFmGT/MzEj9DRK8tRBev1SKfOHYvp0xphBmSrAYRceqNT5fpmhjC5qIS83IO/uB1EhRunqMmqsH55FKTMvx4KYNgaw/tFG3mBMMsd7JF8ypXpQKL2Km2kIL10tT+QiGVFXriKjMRi4CIdDKiPdxETn7QP06oFy1IA4ueTqPPczQa8CXBgA2vjLV6Vhp3+9U5n1TnxKchpm7hskeiQTT9tOk3bySxzd2VhThgeyDGAVRzw743gpfc0CjZuGzLeIQVgr28A/reU8w8bYXyOrijqfPeWZuJND/zHIxZjgL/6j1BbSBxDd9I+jhBlwvGy7BH0GpCdZv8eKQkIFNpwnjQ/guvhjGe+94ibfivpVV0PVCiIXCwsItTQv6acP34HH/EnksZoMhyppyMQFFKtcMMivlFrDNghGZHJTc6c3QlGblyQib9dmIR3YY6tfRQWKY4dTz9ESDNT93ifcDiE8YNqxhDb3XVMwyxC+FhF9KoUh0ZRK+5DTVcda9hsSz9yzSRD6/hPTlarIaKM43YEvWu0q1
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5xUqe31+rkVoRFtUIG458maRB155XUHFTHexN70b8Jt5nVAtytvqdA1i67lD?=
 =?us-ascii?Q?WkK9laLBHVLDbrzqt0MWidQB1711V/cL4ju+3XH2Zv32wu/DG+REavXsv0Yg?=
 =?us-ascii?Q?Rwf0tTsie4dobvgF9f4QscDccYeeA2hk1WcZTzj4LFw4LuY73/l4w2O+8832?=
 =?us-ascii?Q?rcQnXmOA+wLoBOjfi9MzxUmXNURjCQpCV6mSHlR0RC7geIpgKY5EmpY6U19x?=
 =?us-ascii?Q?iI7ci2EjqL/rv01QAsFI18aIp4pshNDjSJwWSyk+Bp8H16ynt7hitJZdo2VA?=
 =?us-ascii?Q?Gq2r5mXURsH752gyZwodKURTdyJ2WNU2g5RU3szIkYrNYOuog88Dd0l3Xl9t?=
 =?us-ascii?Q?F9d8Tx3fXi48iZsqAtX9tKGkeaF2zZsEZmwgF7nO44prrynSlRWkTtYspmGW?=
 =?us-ascii?Q?YmSWiHgXRwx07CiZlvjx1gFhvx95deEkdgYu1c74W8kFTEZmLQVxvXu8RpbR?=
 =?us-ascii?Q?c5KtaJupfHkY/vu+3Zv1h24M3GpsScSdealOI2JVmsApO7euCcR5qWDRKXKl?=
 =?us-ascii?Q?beswGE2H3tPKa/r+KDg7/5xmjiMXC+/uhzZlkQeVm45AA2fA33n1F3iscsUb?=
 =?us-ascii?Q?xfnSPf9et9xuToLAxb5wIez8bM7ZL5MpKu/xLuS277PHOhAa3S82tso/ITSt?=
 =?us-ascii?Q?zFNgwBe/U5iTryCMtB5AHmpACOalUX7pwtrNkR+ulhoBTsLy46Y0YADiTE3j?=
 =?us-ascii?Q?g9JqIDc3sH/aud5iiE9EnA9xJzUDuvZxFlJ7gA40H2W09yOVvnCUIW/m6CCK?=
 =?us-ascii?Q?0XNTTymeFl6yq8HwwAMiwwSNqJKZq0T8QAWsUqVKesZN4DX1OEDhrN36vmM7?=
 =?us-ascii?Q?m7Hdr+CPU1Sy9tCLmUDmqyzyTb9eAeiaUzz+ifLsUzYeiT8neImOomsGdwjM?=
 =?us-ascii?Q?aiuxq4Z3SwIzxouRbjm+waFfzBIWw/BO+IiPKJi51xjEHyfLscy//InMN6wG?=
 =?us-ascii?Q?/dZbQPvvOj7AShvTN29e5kSyRJZSLVRyyiEm4Kbia9ysFTzuR1/wqkQ+rx6h?=
 =?us-ascii?Q?n9zTwsIolI5xspODrdoS01FAWaBfWHZX6b2xf4kgZsnKWldOJvfD2MFXB9Bk?=
 =?us-ascii?Q?P2KnNMR4XXX93KHg4ru56IXfGyoD1wFUYJtPTGLhe6XJguw9llNaRImlZkRT?=
 =?us-ascii?Q?fRZQhG+gesZ/Fog6NVkdYCXGBsB4hpv69prGEYCFisRrsPSgmI7VVrnawuey?=
 =?us-ascii?Q?I36kZrhVYyx05p0TMuY1dDpRmO6grPXG2o74YteNnltw8x2GWSeM6iuiIZ72?=
 =?us-ascii?Q?hE59M/98UfoiYGm3eICh0AdafQwps4k6xibdmEnykPWfqYvpOTPFVlVTIslY?=
 =?us-ascii?Q?FVqpIQiHo4HMOyFshsOYSyLMVsczYd7pfordlZ89fqzTzwY5gY5YlcnUZzaB?=
 =?us-ascii?Q?zTZXaXZKL3rfWuXVhk6k30g8vbbf9Iq7offy28bBc5wAln/Vok12ZxhMbOJe?=
 =?us-ascii?Q?+MYpA4v5u5b3EAAiz+nYhjc/QUejBEDXvHqOLAXGYx3tGkhGs6Gs5Q=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e9a8f4-7f78-415c-c874-08da3107ec1b
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:32:12.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR0101MB4360
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu_linux@126.com>

Let multishot support multishot mode, currently only add accept as its
first consumer.
theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userspace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()


tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

v1->v2:
 - re-implement it against the reworked poll code

v2->v3:
 - fold in code tweak and clean from Jens
 - use io_issue_sqe rather than io_queue_sqe, since the former one
   return the internal error back which makes more sense
 - remove io_poll_clean() and its friends since they are not needed

v3->v4:
 - move the accept multishot flag to the proper patch
 - typo correction
 - remove improperly added signed-off-by


Hao Xu (4):
  io_uring: add IORING_ACCEPT_MULTISHOT for accept
  io_uring: add REQ_F_APOLL_MULTISHOT for requests
  io_uring: let fast poll support multishot
  io_uring: implement multishot mode for accept

 fs/io_uring.c                 | 94 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  5 ++
 2 files changed, 79 insertions(+), 20 deletions(-)


base-commit: 0a194603ba7ee67b4e39ec0ee5cda70a356ea618
-- 
2.25.1

