Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8192211F3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGOQIs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 12:08:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60241 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726820AbgGOQIq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 12:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594829290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IopR+z5meSdmN/y04bfMEJ745CxUYAGPVXvhH7z7Ulo=;
        b=M8vH00uJmg+xbyIonm8F8GUto1zM7W7biX1lN5DX9UcTamAvozo9YsScZfrqhGDpBCU8pt
        I+aGFB2GybICfqXXv8QPR0Ck0m8dhK/pQwuGfuSjx8/Q4R6alQSUrNOuwGYHB6xuHaFlhE
        wBMx5S8JwEGb71jkiq6h7f6hc8CTt50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-jtGalE7DPDC0eh_8Br_pTg-1; Wed, 15 Jul 2020 12:08:08 -0400
X-MC-Unique: jtGalE7DPDC0eh_8Br_pTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E96B100AA23;
        Wed, 15 Jul 2020 16:08:00 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-249.pek2.redhat.com [10.72.13.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07E7F6FDD1;
        Wed, 15 Jul 2020 16:07:58 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] fsstress: add io_uring test and do some fix
Date:   Thu, 16 Jul 2020 00:07:52 +0800
Message-Id: <20200715160755.14392-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset tries to add new IO_URING test into fsstress [1/3]. And
then do some changes and bug fix by the way [2/3 and 3/3].

fsstress is an important tool in xfstests to do random filesystem I/Os
test, lots of test cases use it. So add IO_URING operation into fsstress
will help to make lots of test cases cover IO_URING test naturally.

I'm not an IO_URING expert, so cc io-uring@ list, please feel free to
tell me if you find something wrong or have any suggestions to improve
the test.

Thanks,
Zorro



