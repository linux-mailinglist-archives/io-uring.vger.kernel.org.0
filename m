Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D014637687
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKXKbB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 05:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKXKaz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 05:30:55 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F852CFEA1
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:54 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO4cAZQ006701
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=P6iLpZYIRgxXTgq9XvxQXKX4FeGWquZA454dM6mxobs=;
 b=V0DsWb6oUHvbKpD9IT9/JVMvdNhYlOdJgxR761wZxSugbjaYzE6B2Tht6431t0lFSJHD
 bh7iTGEKcPN/lugUjd12PPg3cXV6uFtSb5RjgjeC0skDcdkTduIcY8O/8V4mmwvpHzFz
 JnS79JiCJBihIWXuRnsI0rsD37duaqJH+pYL5WKbfnxV614GJDesBW3tmcJA8G168Go3
 /aO1tOZzPv/fdzJ50sp6EV0gmv9QBnXBQpU62WpsNiXWQzEVfDdGumiPuiSFU21wogCq
 d0OtGX6fltDFDd6MSg/8ujm9RUj6rqWnwn/bk4+h3SDo4Cu0yxVPf8SbVBmvhYt6wefe eA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m13rmd44m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:53 -0800
Received: from twshared8047.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 02:30:51 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 55825A17DB8F; Thu, 24 Nov 2022 02:30:43 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 0/2] tests for deferred multishot completions
Date:   Thu, 24 Nov 2022 02:30:40 -0800
Message-ID: <20221124103042.4129289-1-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Q9WFDdwYENthGjtft9bDMhexPqAUvunb
X-Proofpoint-ORIG-GUID: Q9WFDdwYENthGjtft9bDMhexPqAUvunb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This adds a couple of tests that expose some trickier corner cases for
multishot APIS, specifically in light of the latest series to batch &
defer multishot completion.


Dylan Yudaken (2):
  Add a test for errors in multishot recv
  add a test for multishot downgrading

 test/poll-mshot-overflow.c | 105 ++++++++++++++++++++++++++++++++++++-
 test/recv-multishot.c      |  85 ++++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+), 2 deletions(-)


base-commit: b90a28636e5b5efe6dc1383acc90aec61814d9ba
--=20
2.30.2

