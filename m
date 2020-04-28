Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C01BC506
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 18:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgD1QVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 12:21:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727957AbgD1QVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Apr 2020 12:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588090909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4SRRyRPA2SyhK5V8mKsODDjqeMDup/gr7BkdcFQrois=;
        b=U9XCi3XVG+ifoZGr9g18WmW/fR8y+DvLu0itB4zD/jNUAPr8nN368SIYzMYn/rPhAvFp2R
        5T7hlP9gA84smwigaCkOM57cC4tFTJDGZIEEWR56OrqC/DNlo7AqFH6iizeClkf4hqcZCo
        jTvHwGOuJR+PfXKjgFABJjJLwCzr9s0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-u6EDMnAyNAOtilCUWt-Mug-1; Tue, 28 Apr 2020 12:21:47 -0400
X-MC-Unique: u6EDMnAyNAOtilCUWt-Mug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6106A420DA
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 16:21:46 +0000 (UTC)
Received: from [10.74.8.121] (unknown [10.74.8.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85EF35D9E2
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 16:21:45 +0000 (UTC)
To:     io-uring@vger.kernel.org
From:   Ravishankar N <ravishankar@redhat.com>
Subject: Questions on liburing usage
Message-ID: <1de2d018-a01f-a080-d2bf-19bd7e11f9f9@redhat.com>
Date:   Tue, 28 Apr 2020 21:51:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I have a couple of questions on liburing usage. I hope this is an=20
appropriate place to ask.

1.If we perform a io_uring_get_sqe()-->=20
io_uring_prep_$FILE_OPERATION()--> io_uring_submit() in sequence, does=20
the call to io_uring_submit() ever return a zero? If yes, does it mean=20
the sqe submission was not successful and a completion event won't be=20
triggered for it?

2. The programs in liburing/examples call io_uring_submit() once a=20
significant no. of sqes are got and prepped. Is it an anti-pattern to=20
call submit once for each sqe instead of aggregating them and calling=20
submit periodically? Especially if the sqes perform operations on=20
different files/ file descriptors?

3. Is there any way to examine cqe members using gdb? I get memory=20
access errors when I try to.

4. If we get short reads/writes in a cqe, is it because the=20
filesystem/device did partial I/O or is it something inherent in using=20
the io_uring framework (or any non-blocking I/O method in general)?

5. Is it okay to mix synchronous and uring based operations on the same=20
fd, especially if the fd is *not* opened with O_DIRECT?

6. Not really a question but examples/io_uring-cp.c seems to be buggy in=20
doing the copy.

 >>>

$ ls -lh FILE
-rw-rw-r--. 1 ravi ravi 100M Apr 28 21:10 FILE

$ md5sum FILE
c2b8ac1f18e65379cc2ab45f8a5f915e=C2=A0 FILE

$ examples/io_uring-cp FILE NEWFILE

$ md5sum NEWFILE
50a9df1f3676bc2c84c67da43022d7bd=C2=A0 NEWFILE

$ ll FILE
-rw-rw-r--. 1 ravi ravi 104857600 Apr 28 21:10 FILE
$ ll NEWFILE
-rw-r--r--. 1 ravi ravi 102858752 Apr 28 21:11 NEWFILE

 >>>

Any help is appreciated.
Regards,
Ravi

