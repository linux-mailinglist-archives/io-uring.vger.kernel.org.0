Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9694B42FFEE
	for <lists+io-uring@lfdr.de>; Sat, 16 Oct 2021 05:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbhJPDic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 23:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhJPDib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 23:38:31 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1BDC061570
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 20:36:24 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id h27so3407897ila.5
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 20:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s3uMFLNwfOsmXbJztfSs/gVn9vPokSAL/2H9Vnm23Tc=;
        b=7HTVSlZDwMCgw4KOFLeAUHRuzd7LH7EvMox2xAHGBV5VnrXpis1gF9LfHTZ8aHIaJk
         qQYeWDrvk8Q76Z2sEt7J8VdyrDuTxSv94HxsKvVkhlXZpSCTm/f11XxQak13khMVx5SE
         j/5zkevx3AN1WbP5K3CaDYiYuJ7HaCtXQ5q4QIMHyCQ59+w4eznmdFdzsQYqQMqQEpwt
         n5Tje1k53BKkYitLKX12gAdpupgwJHEoTK/2heKQi6StA/8bzXHdmEcfWUB7PD0QHml2
         UPmScc0tCYmQWo2D6DfUXUB12afT2FEC/Y0dvVATVuavKiEYj5iK98kzTbOic1Ql8h+u
         QjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s3uMFLNwfOsmXbJztfSs/gVn9vPokSAL/2H9Vnm23Tc=;
        b=Ie3gpZS5xkUuTxalH5W5NU3fGb3QGb39iMYkCEwAQxKAkUUolbYJ1m5xj4jTf7ArOk
         OpDvAocV8rxx1eGw/BniIc//Xn22I4y9w54hWpAcomiSnCzvnyVu7DeD2b60J7EJ+rXj
         NcUtjq6UHVZiGiGcQZP5BEKCvgag+8wZLifJ+9Ch0I1oacfkq4IYjun23XFqJQE1ZYur
         JYBr95F5y1Z0oE6RmFMSifEDbPufFvI8W9w7CJS6YzSrvllICV1Ph6Wghe1ZCs7eG5SQ
         fTdzqtECqlRUXjEY+zk1hc46NWdmbkb+YsDWEUhJKfkxX11ZzcqW6KhGEZ+cg28CnzjI
         m8Vw==
X-Gm-Message-State: AOAM533Usi6lJjEeUqEELCrDXnElzi9jppv4iC+fAedbF3UBRh667d0l
        HwD31iQO86Rz6keU62TzDi5n7C5fkpg=
X-Google-Smtp-Source: ABdhPJwLvAvCHEc6yFGQorNF+7OY7CQ+xpD02zkM6RhAqVa0Pl/uCowLlVBAVZfkUfzOP/t8FlMsTw==
X-Received: by 2002:a05:6e02:1985:: with SMTP id g5mr6909219ilf.158.1634355383168;
        Fri, 15 Oct 2021 20:36:23 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d5sm3583214ilq.16.2021.10.15.20.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 20:36:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 0/8] further rw cleanups+optimisisation
Date:   Fri, 15 Oct 2021 21:36:19 -0600
Message-Id: <163435537289.560258.5526499278850849147.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 15 Oct 2021 17:09:10 +0100, Pavel Begunkov wrote:
> Some not difficult code reshuffling.
> 
> Default test with nullblk: around +1% throughput
> 
> Pavel Begunkov (8):
>   io_uring: optimise req->ctx reloads
>   io_uring: kill io_wq_current_is_worker() in iopoll
>   io_uring: optimise io_import_iovec fixed path
>   io_uring: return iovec from __io_import_iovec
>   io_uring: optimise fixed rw rsrc node setting
>   io_uring: clean io_prep_rw()
>   io_uring: arm poll for non-nowait files
>   io_uring: simplify io_file_supports_nowait()
> 
> [...]

Applied, thanks!

[1/8] io_uring: optimise req->ctx reloads
      commit: 5d946c9385d88990143a2a150ff24fd9d80f9ed2
[2/8] io_uring: kill io_wq_current_is_worker() in iopoll
      commit: 62768ee791cb7c55ffd74bb52ea384bc7457b247
[3/8] io_uring: optimise io_import_iovec fixed path
      commit: 406e1233ec43ee8cdfc13a17a2bebd169e75d7a6
[4/8] io_uring: return iovec from __io_import_iovec
      commit: 200a80aa207869f9e2a0e5b4487d39664f55a85d
[5/8] io_uring: optimise fixed rw rsrc node setting
      commit: 95462452d4c8469490e9396bcf31b582716063a5
[6/8] io_uring: clean io_prep_rw()
      commit: 8b0286cb37b407b04ec2a0c9f2f7908fa606af76
[7/8] io_uring: arm poll for non-nowait files
      commit: 7070f9ad7468e52c5bd36c6270aa4c6466f6bbf3
[8/8] io_uring: simplify io_file_supports_nowait()
      commit: 785d7baa96560c726b68d591a233532f1a203743

Best regards,
-- 
Jens Axboe


