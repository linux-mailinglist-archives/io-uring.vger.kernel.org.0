Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1240145AAEA
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbhKWSLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:11:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239618AbhKWSLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:11:20 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1ANCM0EP029907
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=d/HGfUGrvW4cczkkYlzmURaudBxv8kty18t2+WRReYU=;
 b=QWO1Ga1tZ7ssMuP5rKH0nNCkfAzT6zYLYnkM8f0hNM+cK8DE8tuVP2j4kJWe+GlZ/fz0
 HUi99TUHkVBpmEUcOStt/95qddm/RNm3lzj3lygXp9z1VVeiTWPQKD0qsWw35rI85OqZ
 Pi+DJweFpYDzhXh5XrBCuDYm4UlE5LGVqz4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3ch07y2gvf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:08:07 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:08:04 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D8D566CCCD45; Tue, 23 Nov 2021 10:07:54 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 0/4] liburing: add getdents64 support
Date:   Tue, 23 Nov 2021 10:07:49 -0800
Message-ID: <20211123180753.1598611-1-shr@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: lxMwEV3wd26jvbJej9SiICj9JUE6eP3I
X-Proofpoint-GUID: lxMwEV3wd26jvbJej9SiICj9JUE6eP3I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=632 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the getdents support to liburing.

Patch 1: liburing: update io_uring.h header file
  This updates the io_uring header file with the new enum for
  the getdents support.

Patch 2: liburing: add prepare function for getdents
  Adds the io_uring_prep_getdents() function.

Patch 3: liburing: add test program for getdents
  Adds a new test program to test the getdents support. It queries
  the current directory and all its subdirectories.

Patch 4: liburing: add new man page
  Adds a new man page for the io_uring_prep_getdents call.


Stefan Roesch (4):
  liburing: update io_uring.h header file
  liburing: add prepare function for getdents64
  liburing: Add test program for getdents call
  liburing: Add man page for io_uring_prep_getdents call

 man/io_uring_prep_getdents.3    |  64 ++++++++
 src/include/liburing.h          |   6 +
 src/include/liburing/io_uring.h |   1 +
 test/Makefile                   |   1 +
 test/getdents.c                 | 258 ++++++++++++++++++++++++++++++++
 5 files changed, 330 insertions(+)
 create mode 100644 man/io_uring_prep_getdents.3
 create mode 100644 test/getdents.c

Signed-off-by: Stefan Roesch <shr@fb.com>
--=20
2.30.2

