Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26A0231190
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbgG1SXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 14:23:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22000 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbgG1SXb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 14:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595960610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T8Lqayxj+SLfsKq3xcJRQmNc/Wa0kVL+C1Clq32FVtU=;
        b=St5HyRsS2eQTu80FCBE5JQD4C2+jdKBVzItzA3vnSRUgpVPs+9rpfUyn+WXRkF0JB/eNfg
        PbuCTB1dxpz20t4E7toDpY0dqyrHfVkGW04nlslvLemUkW6afpijtP9FNtxq3P/ygcH19g
        xKKT8isuIKWI/e131qlFlo4SsqY2RfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-op-aRV-QMbyuNtsqKGn_Dw-1; Tue, 28 Jul 2020 14:23:28 -0400
X-MC-Unique: op-aRV-QMbyuNtsqKGn_Dw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6291A101C8A0;
        Tue, 28 Jul 2020 18:23:27 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-108.pek2.redhat.com [10.72.12.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D10BA5DA2A;
        Tue, 28 Jul 2020 18:23:24 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH 0/4] fsstress,fsx: add io_uring test and do some fix
Date:   Wed, 29 Jul 2020 02:23:16 +0800
Message-Id: <20200728182320.8762-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset tries to add new IO_URING test into fsstress [1/4] and fsx [4/4].
And then do some changes and bug fix by the way [2/4 and 3/4].

fsstress and fsx are important tools in xfstests to do filesystem I/Os test,
lots of test cases use it. So add IO_URING operation into fsstress and fsx
will help to cover IO_URING test from fs side.

I'm not an IO_URING expert, so cc io-uring@ list, please feel free to
tell me if you find something wrong or have any suggestions to improve
the test.

Thanks,
Zorro



