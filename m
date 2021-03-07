Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5941F330030
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 11:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhCGKzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 05:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhCGKz3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 05:55:29 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72C9C06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Mar 2021 02:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:To:From:CC;
        bh=539ySbCpIx7enFJDL9vE/KK0P2k7DrS6QFpWrlNLVPE=; b=ZnC96LmzZmCfyYlJxUK9G/xi9z
        jI7O+1ryl2vZFa3eKQAhEXE//aTybMGusZjNjKgu1dvxk65qCgk5r9MfIryEQPVOUq/5aaB6xp+E8
        ULN8SgVlLZO2+dqqaG9TD5L/RQ3RmJbb6WJQ6rGkwjpEmyZKiblnwdUhgLdu9xrD957ds0OhJ2VNt
        E4eNE+sCedN+B1p/MHpIAga22aSBDaPyVOOU48OQAb4vta5xfi6IO49RmYLxZe3V/qkgK3Ni0H35N
        ze//zFtarY8mG3x0PwxiKAp5qZKHjg+XxnUZIcwkWmdR/qJev5ETlZaK/5SddFcOGVQPIqEM66k6a
        5NEZZaFDcsAKLuq3By/cf9iOtqg0B1MOHeVnWR3tmWj1C+NpP7wrtuAbL+thUj9alsC2nEUjAhbjX
        eJwMPjgCUa44uqWPi0sUw2nNxXaWwdQDYpgubV3ll9C5vSyR1eLgi+vRSb6fx0Kefr4v0wrNNKF+L
        Dw1mwpT6sDl79kcicOvw5/J9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lIr46-0000O0-TT
        for io-uring@vger.kernel.org; Sun, 07 Mar 2021 10:55:15 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/2] Restore sq_thread 5.11 behavior
Date:   Sun,  7 Mar 2021 11:54:27 +0100
Message-Id: <20210307105429.3565442-1-metze@samba.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

I guess on top of your "io-wq: always track creds for async issue"
we want to following to patches in order to restore the sq_thread
behavior of 5.11 (and older) with IORING_SETUP_ATTACH_WQ.

- io_uring: run __io_sq_thread() with the initial creds
- io_uring: kill io_sq_thread_fork() and return -EOWNERDEAD
- io_
I've not tested them, but they compile and as far as I read the
5.11 code, they should restore the old behavior.

metze

