Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01911B39BF
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDVINy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 04:13:54 -0400
Received: from st43p00im-ztdg10073201.me.com ([17.58.63.177]:42511 "EHLO
        st43p00im-ztdg10073201.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgDVINx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 04:13:53 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2020 04:13:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1587542666;
        bh=IlRFzj7EEheBdI/Nmh4RvdJl0iS2iiGE0xw/RqanQy0=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=Khxa1aJglTchXVFm+QDWI4kAA9PVSOGv3Cj7n2twpz/tFamu3ioj/+hQseAuCR149
         BdMlqSfrplUHz71BaDz6jLvVoIBkj0VdN9ISG4Met1MO6tE8cqXgupgLqo2P2hDA03
         Qs/1JyR9eOp6ZyVmvQ/kdKoVB8KK5o/ceYhPUxB3xcbuufSLdd2NE2HYaM4Q9I2jRG
         KWoX8fxxd//jvi+m/1P+3ls5U+82XUDUqYuAGisBxSG13BnMEMSlqB+U2dOoCk+PzI
         wM6KkA7r2CsbcsE8JS4C3WZ/9dlb5BtZaFxJ+citA/Otfqat1xiWuPyb4EIeqtlXNQ
         ozLyKS5/IIOIQ==
Received: from [192.168.0.102] (athedsl-4502887.home.otenet.gr [94.71.161.111])
        by st43p00im-ztdg10073201.me.com (Postfix) with ESMTPSA id E1468221B5C
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 08:04:25 +0000 (UTC)
From:   Mark Papadakis <markuspapadakis@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Feature Request:  SQE's flag for when you are not interested in the
 op.result
Message-Id: <233BE31C-B811-4715-97B6-7E3F965A5137@icloud.com>
Date:   Wed, 22 Apr 2020 11:04:22 +0300
To:     io-uring <io-uring@vger.kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_02:2020-04-21,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=412 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2002250000 definitions=main-2004220066
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When e.g manipulating epoll state via its FD, most of the time you =
don=E2=80=99t care wether e.g EPOLL_CTL_DEL succeeds or fails, or you =
know that it will =E2=80=9Cnever=E2=80=9D fail. In such cases maybe it =
=E2=80=98d be beneficial to support another IOSQE flag which, when set, =
would instruct the io_uring to not include a matching CQE for that SQE =
when processed.
It=E2=80=99s not a big deal, per se, but it would probably help somewhat =
with performance.

@markpapadakis

