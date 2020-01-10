Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F83E1371A8
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 16:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgAJPrm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 10:47:42 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:44065 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgAJPrm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 10:47:42 -0500
Received: by mail-pg1-f174.google.com with SMTP id x7so1171861pgl.11
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 07:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7u685f2L9+jaOz+HCh7JiAVcK59LzFp/aZgY0iyCtcc=;
        b=Rhkl9uRn77mVhePvZ/x8FUpLU5lBp+aPDxU3+U/P7gFNB5BNp3Ci5gRPBD6opA/1lh
         t0u1dmdo2h3x87qWRQ4qwoQKzUrstsmQAcp/sxfnKubnA9Nuqs0da4UAxwzyJRjavIJC
         /erfeUknqoeUeNrlXjSViY6GQvRY41EmEbO/Lv3+fe3M/OYH/xCM/QoU5voWxl9wnI7q
         XERksJYI1WTzvIN/2d3rFc5jp+BrmxgFttdNyCENrjC9NimmGDzudfufAemJ+tI7tqPx
         ngQRTRzakAOVpGrx8r3Y2sxk3KAcbMM0V7Ww1UFeBLC8TJ2ZVWzt6FVAMYwLmhpxQO1W
         10kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7u685f2L9+jaOz+HCh7JiAVcK59LzFp/aZgY0iyCtcc=;
        b=TZySF9FICEAm46EuN9IASKHoofnTP+YgYRUCf0QZNSA4LfRyYHDn0nVpfNCQRLY/fQ
         pbhXzyN8aovQut4xE24sP9uRbaNp/AzWYzWboVkQUJrbiKRQNkOeU2HQXUm/L2sYkGJk
         4nxkDTaeSEwfzBqdC7+9tjpOWig1Ef7WAIQj0Wo3SC75bI7/OuiqoaOPHnB6+E5iYMF4
         bcewbiNpxa8IrF6R8BNtPw32noqCFI+lN7auHopDHx6ILbNE1J9kDEIIKHwyKnAQSg0Y
         e2+dKnnlX83Ule9YPA8tjeDXRWLWSabpSaiHjphUX8OcbHZo2bFftKU3TlDgvQmN70G1
         0jTw==
X-Gm-Message-State: APjAAAXOkd58F62+RBp5YurDlRAOdkYRtBRSdn/xdSBIQZgqr4a26TOU
        Ul507Vq2FF2N2G6HZxn3If42WJMvAoI=
X-Google-Smtp-Source: APXvYqxJ17D8iSmjKOv0S2rNWY8y7KffM7W9AZcZOwRXnp3zR9jsDuzXwvPfEPReGAywTlqjX7HmOA==
X-Received: by 2002:a63:1b0a:: with SMTP id b10mr5170711pgb.56.1578671261678;
        Fri, 10 Jan 2020 07:47:41 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 3sm3489520pfi.13.2020.01.10.07.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:47:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCHSET 0/3] io_uring: add support for madvise/fadvise
Date:   Fri, 10 Jan 2020 08:47:36 -0700
Message-Id: <20200110154739.2119-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nothing earth shattering here, just wiring up madvise and fadvise for
io_uring. The madvise part requires a small prep patch.

-- 
Jens Axboe


