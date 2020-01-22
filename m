Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9321448B3
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 01:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAVAGL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 19:06:11 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:37319 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAGK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 19:06:10 -0500
Received: by mail-wr1-f54.google.com with SMTP id w15so5438101wru.4;
        Tue, 21 Jan 2020 16:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+zEcwis6ThXfT6mloNcDub5UhY7saRP+atehPWXbg8=;
        b=pd+w6iy4YfZTG6ykUdSO1TopUQ12Jv6roaH0TcvurH8bkSdsLNUR5XlfusQZys8jb7
         n0ccud8Vk8MPYofAVlXGh2qTO4hga+4PaQsB1WiRCiZ2fW1d/bwzWXUXmX8K3pcerq4V
         p0cz/RpdezhVGDVIlSIgcKBhXmQEsqNaxEEbz/+cyGA+qByQZ2hGt6+pXDytk6vuxxhP
         NsSZ97Wpa8QgUh5cnZaAKZXiKy+8XHOSJD1dpYwl+XLG5TrcfcVBUoD74P601uuGJszJ
         d4C4xNOzei3ajlTz3yYa48LkE1KhPMie0nJTbMm6czwCk0UMMYY60U63MtrCIwu1Isnm
         u/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+zEcwis6ThXfT6mloNcDub5UhY7saRP+atehPWXbg8=;
        b=qlHde4rQVwaUp5NgGokcasbLgXzC1ATaDoVYWedcd/OqLA9NL1TsLpWVQICkwQcS0k
         7lNrDeocsLF1rWxBAL0RqRTOoL4QO9VmOszJ85qPBYB9OCQnT/9suDa9/qNG5qHFA20O
         A0uUDxuIgiGwIRxRsQ2v6RfTYWpU7LMUFEIP9Y0UCFN+KXeNdoXhvd0KWiD3L8HWeXKi
         bn2Tm51EyOLuyVyNRYGBh8O4BcysyN0I+nviwp8jkeuPH35fhXAC6kFRsQRk43BiMmLk
         DAeKdt2YQfwGw4glNVm1Z2GEwB7YYyGBTU4gCXTfpew7QonFrLnB/XWsCuOlucFVZDUE
         5o/Q==
X-Gm-Message-State: APjAAAU29B9vH4oYwWMECt6Wmtw5cEB0AeGl4pzxOsWqGkJWUbTX9sxZ
        5spivxQalwBbcw1qj/iCP1fVx4RP
X-Google-Smtp-Source: APXvYqz4uwvRFSatzkcA5ap1t5Hf5v+Km0/1AT8ntk0tClPEZiprUcwpm4D70VT4r31uJR1MHO5shQ==
X-Received: by 2002:adf:e984:: with SMTP id h4mr7748945wrm.275.1579651568492;
        Tue, 21 Jan 2020 16:06:08 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id o4sm54527068wrw.97.2020.01.21.16.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 16:06:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [POC RFC 0/3] splice(2) support for io_uring
Date:   Wed, 22 Jan 2020 03:05:16 +0300
Message-Id: <cover.1579649589.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It works well for basic cases, but there is still work to be done. E.g.
it misses @hash_reg_file checks for the second (output) file. Anyway,
there are some questions I want to discuss:

- why sqe->len is __u32? Splice uses size_t, and I think it's better
to have something wider (e.g. u64) for fututre use. That's the story
behind added sqe->splice_len.

- it requires 2 fds, and it's painful. Currently file managing is done
by common path (e.g. io_req_set_file(), __io_req_aux_free()). I'm
thinking to make each opcode function handle file grabbing/putting
themself with some helpers, as it's done in the patch for splice's
out-file.
    1. Opcode handler knows, whether it have/needs a file, and thus
       doesn't need extra checks done in common path.
    2. It will be more consistent with splice.
Objections? Ideas?

- do we need offset pointers with fallback to file->f_pos? Or is it
enough to have offset value. Jens, I remember you added the first
option somewhere, could you tell the reasoning?


Pavel Begunkov (3):
  splice: make do_splice public
  io_uring: add interface for getting files
  io_uring: add splice(2) support

 fs/io_uring.c                 | 152 ++++++++++++++++++++++++++++------
 fs/splice.c                   |   6 +-
 include/linux/splice.h        |   3 +
 include/uapi/linux/io_uring.h |  16 +++-
 4 files changed, 147 insertions(+), 30 deletions(-)

-- 
2.24.0

