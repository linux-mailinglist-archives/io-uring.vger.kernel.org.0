Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCEB1538B8
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 20:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBETIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 14:08:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52281 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBETIa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 14:08:30 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so3687324wmc.2;
        Wed, 05 Feb 2020 11:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jj6fgSmpt3U2vE30272TJGECHKQ1zPe4wc+AxvAsp48=;
        b=VO7jeWb6J4PPwqik1pme3VOzZ17RRdidQUQbrC6zis45E794vQO7SQPnwBotjXVfev
         KmWMWhZHmtJuxP23h+wdQtPUvNMIAz55qwje6O+CvUq0q/tGCoa7Mh0qfh5dC9tNUO5s
         7APjq6xqCDAOzvlHWjkzmw4pYHfmA757uzRUZh/3jiggDCKG4CJRSy7pIzwQH0CJ8kIp
         SvCfxSGNPlIJcRFXWSSZC0hX6aoNgaQqjkf70leP7sjEHqwf+9WBkT+ITGTLw/zDzkj8
         Usge4KPy0TXWZRk5BnPYs11rIlwYl6+zj40ymGxCOJDIuGlSzJsgwg1QKX4hRWtykPUA
         HarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jj6fgSmpt3U2vE30272TJGECHKQ1zPe4wc+AxvAsp48=;
        b=DgLlYtWLx/h60BHQWPFYry3416OkDjHwrCWmA9IQ2G7mhYcgoep7TJAIhUVgALAqzq
         NtTUYX0qkK+gTshbJAbgajAId6HDp2u2i2wGrly3LZdrxjPds+r0zaAy6Y5hB40eAEPt
         8eaQYPzLr6MmFdD1q3/elBsQ5G8dwAoVyD+qCqkmS1qxdnACroDmmhOUQnwFQmbS66i5
         uNDbAA/SGSJPhcNIS9J2XkvEqkGR16+j8ddnKuQMwEzkllDY/luadqpYZlCyansUb+AY
         JllGb/ApeN0JXsL3ZnW/MxxHypWAFmfZHW96/5Hm47GUqW7E4ISVkhSCXnF35OIK1+XZ
         Llsw==
X-Gm-Message-State: APjAAAWxK6nsmK+Q+OO8cw7hb3sMD0CtGGywHJpdpy3ikW1dK5QMx288
        Mpg2hVNGCJkgW+0E7zX8TZ4oB+tN
X-Google-Smtp-Source: APXvYqyOCqN+FF5St5VC3smXTj/yi39kfVzpZsEENyx20Jp4Tmm9EGNeQnsjiI3iLt+RTOfF+wvL6g==
X-Received: by 2002:a7b:c8d7:: with SMTP id f23mr7053532wml.173.1580929707037;
        Wed, 05 Feb 2020 11:08:27 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id b10sm915568wrw.61.2020.02.05.11.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 11:08:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] io_uring: clean wq path
Date:   Wed,  5 Feb 2020 22:07:30 +0300
Message-Id: <cover.1580928112.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is the first series of shaving some overhead for wq-offloading.
The 1st removes extra allocations, and the 3rd req->refs abusing.

There are plenty of opportunities to leak memory similarly to
the way mentioned in [PATCH 1/3], and I'm working a generic fix,
as I need it to close holes in waiting splice(2) patches.

The untold idea behind [PATCH 3/3] is to get rid referencing even
further. As submission ref always pin request, there is no need
in the second (i.e. completion) ref. Even more, With a bit of
retossing, we can get rid of req->refs at all by using non-atomic
ref under @compl_lock, which usually will be bundled fill_event().
I'll play with it soon. Any ideas or concerns regarding it?

Regarding [PATCH 3/3], is there better way to do it for io_poll_add()?


Pavel Begunkov (3):
  io_uring: pass sqe for link head
  io_uring: deduce force_nonblock in io_issue_sqe()
  io_uring: pass submission ref to async

 fs/io_uring.c | 60 +++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

-- 
2.24.0

