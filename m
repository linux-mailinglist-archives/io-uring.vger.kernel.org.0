Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76A14EE74
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAaO3w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 09:29:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728827AbgAaO3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 09:29:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580480990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PejrRp0WLHfGD9bvxIDUPY9VeT1zBnFCJg8McZ4Axj8=;
        b=KTPgREVzU1HhZEqzN8p6BlPFaDnDfaUPPvy9fXXEsY+JQ+FXD+MaJijYGXY3xGzk3WvQ3z
        uW2mUErG+zOD5sRiJ7KhyIKhLHVZHPyj2ZYw/hbsG89i13MEccurHDuBDRkdc0ityFyqva
        NlXnnEFu95NTSi1aTMaf1Xx2kvZwSLs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-_dEwtEeSOGi2Cnu9b6EtTA-1; Fri, 31 Jan 2020 09:29:46 -0500
X-MC-Unique: _dEwtEeSOGi2Cnu9b6EtTA-1
Received: by mail-wr1-f72.google.com with SMTP id h30so3433766wrh.5
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 06:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PejrRp0WLHfGD9bvxIDUPY9VeT1zBnFCJg8McZ4Axj8=;
        b=hIju7KXquFgE/NmrnpDVnqIV3HXtYxihjfSrX2rhmcZt0cULN2Ur6VvshIdBtJ7vjc
         2siQQfr0haqASgooCf7cU3I23OySmApiLHVxVQAZu2k/qM1TvuNeGROAONtbj2IZvDkf
         mqUGPynmCeYos+B1uNYPsE98+TkKOxxBw1YNfThFFuVlrZ6d7xXmDp6aufjM7iqT9yuM
         CULCeeY0AAF4XoT2xeVPGmg07YsAN8KA2gFLILCOtMNG4GJ8kRZFDu2RpVqZVLqEuLuL
         czWDbHo2x+bFls3qK3kfLWxtShTkma+jRi4FRXxncAfSdvLQqsuJofN7OEWuOpyCEELG
         BaIw==
X-Gm-Message-State: APjAAAWgeJPso5KdiDOti63ypIOZVzaDOQf+70Tc+aVm3KD4s74bNlt2
        qp7Z/s3HHX+ON/+rhguBewKXgWJ/v0qqCr6zW+0rF7jZpFnC194ec7mcPH8oKWMONFnJx/5QnuJ
        NE1bts+w/NLuBxGz0Og8=
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr12704423wrr.104.1580480985569;
        Fri, 31 Jan 2020 06:29:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRMCxZHckpDcEhNoxHFfQhtFNCylRmCEGUWCEZZXq7Gu5uARj7G8YWRmdg39dMpUlGXg1t/g==
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr12704407wrr.104.1580480985325;
        Fri, 31 Jan 2020 06:29:45 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id z19sm10394558wmi.43.2020.01.31.06.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 06:29:44 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 0/1] test: add epoll test case
Date:   Fri, 31 Jan 2020 15:29:42 +0100
Message-Id: <20200131142943.120459-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
this is a v2 of the epoll test.

v1 -> v2:
    - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
    - add 2 new tests to test epoll with IORING_FEAT_NODROP
    - cleanups

There are 4 sub-tests:
    1. test_epoll
    2. test_epoll_sqpoll
    3. test_epoll_nodrop
    4. test_epoll_sqpoll_nodrop

In the first 2 tests, I try to avoid to queue more requests than we have room
for in the CQ ring. These work fine, I have no faults.

In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
much as I can until I get a -EBUSY, but they often fail in this way:
the submitter manages to submit everything, the receiver receives all the
submitted bytes, but the cleaner loses completion events (I also tried to put a
timeout to epoll_wait() in the cleaner to be sure that it is not related to the
patch that I send some weeks ago, but the situation doesn't change, it's like
there is still overflow in the CQ).

Next week I'll try to investigate better which is the problem.

I hope my test make sense, otherwise let me know what is wrong.

Anyway, when I was exploring the library, I had a doubt:
- in the __io_uring_get_cqe() should we call sys_io_uring_enter() also if
  submit and wait_nr are zero, but IORING_SQ_NEED_WAKEUP is set in the
  sq.kflags?

Thanks,
Stefano

Stefano Garzarella (1):
  test: add epoll test case

 .gitignore    |   1 +
 test/Makefile |   5 +-
 test/epoll.c  | 386 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+), 2 deletions(-)
 create mode 100644 test/epoll.c

-- 
2.24.1

