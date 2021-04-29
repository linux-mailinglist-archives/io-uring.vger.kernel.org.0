Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2366C36E276
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 02:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhD2AP4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 20:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhD2AP4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 20:15:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301FDC06138C
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 17:15:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so6290818pjb.4
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 17:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=TvDH0Ufqq951p1SmGaor3zZZi0JBju1aRHwGT5Ex+6c=;
        b=qBqSa5y4lwZrW9yJxdbfp3up47xMlGY3ERU2Co6DLeMlTxHgOl33wHQ7Qedh4ZnPOp
         cEmCFYj9QBM+WVEZSl+PD4fQhn2nyARttU63UzBKkQIOvQ7lopOSQb1EB2xfujQUGYqS
         DOLhNC7xvTPHWXEYRz8S9N2tgfqd4+vD23c7/HzxbSoPBbcO4+XporMn8ZgRszB880Fz
         PHg+k2WVHn4PzCP5qUb8IVjQAVxME/4YwfpuH6RNbK93xLHYrZIiexW5WqysXcbWIcdF
         EfY/yjMH9v6thuJDKO2fhkSJoIWAVp6NAktrn/mdYCOM3fMiUtp/ZOGn9kjk16UYSeap
         kB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=TvDH0Ufqq951p1SmGaor3zZZi0JBju1aRHwGT5Ex+6c=;
        b=iQ/v82XKCf15H/THk/cdMEqZlGjw/baradSzZ1jMLQVCpeyxYHAlAvvvz4TWS0btuR
         qDEZVTgZzSys/0csKt1Q6vqvPPb4i9ChLc8yNnUpjUimF04h3jbpQjdZtEHZdb1ArOgi
         E7CkychE7ahzTzTUNi8YBLejmsqJwb6QKTFBzBeqJUETMxmJ2mIryrji84KlDQoEMjVH
         YNKIAsL0gCebCXp3jxrF6RwZaqE+1ZXLnzoFoiI7zA+g1C5y+1WEYB9uLiVYB6TPnY6/
         pZZKJYZMTdnkJ+4hwcl2bb8dfeNRn1CibzvvlWtHYSnmijHC69TD2xRlCntoNhEawANm
         u5Zg==
X-Gm-Message-State: AOAM531qZ1WXz3bkL9cQyq/olk8czFgIz/xrJ2GoIkCe94Cg+Y7yLt9v
        39Qc9eT9bSzZPl48K+NY7fvcT5NfXFLMT641k7Q=
X-Google-Smtp-Source: ABdhPJzaS8iuASekFzePJRCv/4h3Mp4EuDBzGJNNr/KrR5gadsFo9jSHiYVf0bgSuybLyaJzun+sT1rdvSYrhl+Xpjg=
X-Received: by 2002:a17:902:d70f:b029:ec:b679:f122 with SMTP id
 w15-20020a170902d70fb02900ecb679f122mr34035019ply.38.1619655308836; Wed, 28
 Apr 2021 17:15:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:6426:b029:19:764e:b00a with HTTP; Wed, 28 Apr 2021
 17:15:08 -0700 (PDT)
Reply-To: bwalysam@gmail.com
From:   Mr Kingsley Obiora <maryclove123@gmail.com>
Date:   Thu, 29 Apr 2021 01:15:08 +0100
Message-ID: <CAFBdPmcHES2tj56kGhDYXjigWTO3OJYXPKgPOPe=6rF5B5p=NA@mail.gmail.com>
Subject: Hello From Dr Kingsley Obiora
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear Sir,

After our meeting held today based on your funds, the management want
to bring to your notice that we are making a special arrangement to
bring your said fund by cash through diplomatic Immunity to your
country home. Further details of this arrangement will be given to you
once you acknowledged this idea.

Waiting for your soonest response.
Kingsley Obiora
