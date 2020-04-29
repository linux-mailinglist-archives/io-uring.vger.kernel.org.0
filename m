Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A621BE272
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 17:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgD2PWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 11:22:03 -0400
Received: from st43p00im-ztbu10073601.me.com ([17.58.63.184]:54565 "EHLO
        st43p00im-ztbu10073601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgD2PWD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 11:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1588173722;
        bh=F0La/J30n6/q8yysInl0YbLhhqXBLvB6WulJrxWoh7Q=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=am6cCO56mi0mCcmEBCOzupMgU4DegJq6TdwIyEvA6c02xG4ruP0kHyGeFpm/RSc4+
         ih6N+UeSnBwbbfyqQexrh3VZ2aKwUwbMro5gfipbjxayjPX7eidhP4GNRfSJufBZLs
         3q4FQxC/XdcsrgdZlqoWOPOexXso7GjTZ62eToG426VIYgAbNY/u2HZDJIdKL6xp8y
         XuCt+LiiHetFYU1PTtjHHvrbCns8aFSDQBBRcbyi8YXHEUp0iSm385zvIh9x0ABDVA
         W5mTY+5zMlmOW2/OgKDnqbXr3cNPiugHjzmkgU6U0lQppwqQoP9dbgEy41ePorzr1W
         CJlI70yK0OyMA==
Received: from [192.168.0.101] (athedsl-4551761.home.otenet.gr [94.70.64.89])
        by st43p00im-ztbu10073601.me.com (Postfix) with ESMTPSA id 63BA88208B2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 15:22:02 +0000 (UTC)
From:   Mark Papadakis <markuspapadakis@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: SQE OP - sendfile
Message-Id: <8B8CEFE3-DDC8-46C6-AE63-4990D677A770@icloud.com>
Date:   Wed, 29 Apr 2020 18:21:58 +0300
To:     io-uring <io-uring@vger.kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=704 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2002250000 definitions=main-2004290128
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings,

Are there any plans for an SENDFILE SQE OP?
Using a pipe and 2 two SPLICE ops(using the LINK flag) for moving data =
from one file FD to a socket FD(for example) works - but it=E2=80=99s =
somewhat inconvenient and maybe more expensive than it would otherwise =
be if there was a dedicated op for a sendfile() like facility.

Thank you,
@markpapadakis

