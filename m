Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4339D135C0B
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgAIO6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 09:58:16 -0500
Received: from mr85p00im-ztdg06021701.me.com ([17.58.23.196]:39447 "EHLO
        mr85p00im-ztdg06021701.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732055AbgAIO6Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 09:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1578581895;
        bh=hHWKTZmVz6E9tqpH+pP3j2ANssvQuXEcmg9EhsFIAls=;
        h=From:Content-Type:Subject:Message-Id:Date:To;
        b=Dg2xMIXFDpDTwzeJrMmRxRYdvvoXG99Wz5ujqe6Ix6Me6Us3ZcvqGBP5V2umbT+/0
         H3VfSTOVsav0Jo8dc1FVErv8hD10PWNm2wJTdbn/hEJBcgiqLLMNd6N6k/AgMAjwxY
         wdN+MHYNSMDkxVDAMMFpgdR6UMtAReUZ7KBTsqjVKD8ngc1Xo0a+BgpUd+HlVF3VZt
         9zW9FhisoZk+8/o3gMc7rcO7dAVQOMXFebR7qSCTiwwXqJA5klem0uckPpHn9s+XcK
         44dIRSNnXuii+bncW4iFjeBJu1fpU4iicTZYnhbmgXa/ZBalsOyyLTNNZwrtkz2am0
         2VBgQuxs8YNnw==
Received: from dhcp.her (louloudi.phaistosnetworks.gr [139.91.200.222])
        by mr85p00im-ztdg06021701.me.com (Postfix) with ESMTPSA id 2E785A0127B
        for <io-uring@vger.kernel.org>; Thu,  9 Jan 2020 14:58:14 +0000 (UTC)
From:   Mark Papadakis <markuspapadakis@icloud.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Feature: zero-copy splice API/opcode
Message-Id: <CBBC10BD-9497-4248-9E6A-AF2DE788E401@icloud.com>
Date:   Thu, 9 Jan 2020 16:58:12 +0200
To:     io-uring@vger.kernel.org
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=461 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001090131
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings,

I =E2=80=98ve been trying to replicate the benefits provided by =
sendfile() using e.g O_DIRECT access, together with IOSQE_IO_LINK in SQE =
flags and MSG_ZEROCOPY, but it doesn=E2=80=99t appear to work. Other =
ideas didn=E2=80=99t work either.

I would really appreciate a sendfile like SQE opcode, but maybe some =
sort of generic DMA/zero-copy based opcode based on splice semantics =
could be implemented, so that e.g a vmsplice() like alternative could =
also work.


(That would be the last remaining bit of functionality missing from =
io_uring, now that Jens has implemented support for IOSQE_ASYNC, =
IORING_REGISTER_EVENTFD_ASYNC and for managing epoll FDs, for enabling =
support for io_uring on https://github.com/phaistos-networks/TANK ).

Thank you,
@markpapadakis

