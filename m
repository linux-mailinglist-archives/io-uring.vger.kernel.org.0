Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B6241C2A5
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 12:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245520AbhI2KXK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 06:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245326AbhI2KXH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 06:23:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94024C06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:21:26 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r18so6528400edv.12
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 03:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8nRwse3IQh2xdU69No/P1pguoxTR+PozS3qr6GPaQEA=;
        b=Fo/alhKCiygBRY1TZg9dRIXOF/79kRpWmIg6cuk18Z5SGHvgjVYePRKLNNreUWoSb7
         vzpMwGrGOYCLVpr99ZhD7oNvYNXqr9god0KR/0GjhE3yN44FusHISN2CV5dAzAgIowSX
         6s3685cbQ4209zR0HJHN5LZjUC6FlexQWjKFK2B3pj4SLtKIzf89xi6OHPUqK37gonLZ
         ukaUzK/ojyfL6LkEXnG5Fx06IbTMa6+AvDa/9LmAejRRf2nVJSPyAvvR+xUqOUpX0VHk
         b+OrQ6ewMDuG9TqJ1BJKa3ZTEBoRyBB0l4dGsftCscpx2YMdsbnMJ4yKhD2qtjBLtl7R
         CNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8nRwse3IQh2xdU69No/P1pguoxTR+PozS3qr6GPaQEA=;
        b=MlDU87QntfEr01h3HWFg8j1/El0TcGItL+m2un66xn96HLV7eC19MFpOXCEtzyY/is
         k+4Pd1/QFa2f0HctFmT0wY1+DTbmvebVY2iOwGm9vFitVUDDyBIBj5WvhGkMlSqjlrCk
         w46UTj5PU+tWlhB28zPebulkTLRDTnEwMNgF4gM1GDBslO9b+IGf6ifQvnK6e2jKNUqB
         oi6s3t62YBSyN1L8Pq3rIcthWWwNHBhFtPRcFU1CtDoIIDUP1zUORaS8HlGBkQcprxKl
         nXg4q1vzRlylzAH52k3SmlcxYXxjE+dYrlVQkwLmcRMUX50R56d+/62iukQqkTf2qruq
         g4iA==
X-Gm-Message-State: AOAM531Y7x0SXTk2rSPvrBa4yyqiE7OFA6BCS/k2hp0Ies7Qq9INUmIS
        H7BuKAFQbZiBqVvI5EL4TRNPaRHZqlO0szbqOhZSow==
X-Google-Smtp-Source: ABdhPJwisALahXXXcm3nL4DtxYDxsvaRyQfiN5/+i/suIjaEiUMt5567ker1zGpRBbEK/X73txM0LIb+xTYViaROaKU=
X-Received: by 2002:a17:907:e91:: with SMTP id ho17mr9075583ejc.287.1632910884766;
 Wed, 29 Sep 2021 03:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
In-Reply-To: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Wed, 29 Sep 2021 17:21:13 +0700
Message-ID: <CAGzmLMX5X45jukOgWuT=+FLvh4eq=mRZ54Rgh1J1W2U3f69fPQ@mail.gmail.com>
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Implement the kernel style return value
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for the title, the patches should have subject
[PATCH v1 RFC liburing]. I missed that. Will make sure
to pay attention on it for v2 and later.
