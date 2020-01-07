Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1E9132C80
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 18:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAGRGH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 12:06:07 -0500
Received: from mail-il1-f180.google.com ([209.85.166.180]:41524 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGRGH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 12:06:07 -0500
Received: by mail-il1-f180.google.com with SMTP id f10so181147ils.8
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 09:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oe+m8T3k8jYH/7kscAp0JIlhgE2YMV0mW5WuY1zrAhI=;
        b=a7k6fW/w7ITvAmrKffOoRBqw+4FugQSOJR5+eOUnR6gNZ6/TJKozNu04D+6qlUIRrW
         M+xG0kyZSJJIvcifzsNnD+TAvO0KScjpulU4dL2SeZyGTxks9iK1ZrvWqJ6BbiranF+d
         QPkcjGBkBBJ976NX7X2KNiO9SttQFiEf1HHyytbrGkmFYwJA+ANaR3PMG6U61ifv3YTm
         qJ+HHxIHBPlpVnzZVd2j9TUroERYqpn2SSCC/St+WvtfvufVLS7Sax3pUJn20c5dLlUx
         ucrUcnYojAJD/kCBCufBzTHar0pwGuKgM/N0YM1oUmfgR+JGVyljQDa9BNZBL0UTUY6j
         NL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oe+m8T3k8jYH/7kscAp0JIlhgE2YMV0mW5WuY1zrAhI=;
        b=Ml6DGgf3PftnbuuqOXFgbOPM5h6cFEryH0D9FfXZVW+73jpKil/hO6BxdtFLOqlr6R
         +fOJ0KDfhp0sq+1GjeDsZSDF5OkfmA+rUV8ygtvvR11Rr0X9msJy9KQE18xHBMml6Woo
         Rm2jdCRjf5FsqzqblZqMJIuDrM4+CGSNsqXDNRnOX2Q15s9dZRrRFt3/yvcBgMcwKRTe
         t/6xQ7v7nTzNLxv+dyfA3xNubBkALtxAhbzoakeiyYdk3rHqFhEDyYp50jaRsnUfN1Qw
         Yx1/7RrTfosiF3ruesCCmWHLxfyZscWlXWsFhBTV9u+izKdoisSSvQ31tKmGVour6/M3
         Rs5A==
X-Gm-Message-State: APjAAAUcPgMcDnSYbza8Xx01fjV8GJBk95kcsuNAdxnoT4J3YtM+hZx7
        JNwZsdhRdJinyTps85inR9ATitoof2g=
X-Google-Smtp-Source: APXvYqwiDh4VEVA9Y8Fa7FseSW0gACVyp+MWuNAWVvILMQYdCXAyK6EBVTLsPkweX02ZDkmdKmBdPw==
X-Received: by 2002:a92:afc5:: with SMTP id v66mr17764ill.123.1578416436985;
        Tue, 07 Jan 2020 09:00:36 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm42547iln.81.2020.01.07.09.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:00:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCHSET v2 0/6] io_uring: add support for open/close
Date:   Tue,  7 Jan 2020 10:00:28 -0700
Message-Id: <20200107170034.16165-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sending this out separately, as I rebased it on top of the work.openat2
branch from Al to resolve some of the conflicts with the differences in
how open flags are built.

Al, you had objections on patch 1 in this series. Are you fine with this
version?

-- 
Jens Axboe


