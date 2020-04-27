Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06801BAD54
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 20:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD0S47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 14:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgD0S46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 14:56:58 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FE0C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:56:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e8so17758447ilm.7
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lonelycoder.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpQs5XKfADQ3M323QC+V1TXEIIA5lhyXKfjNkqvRn0g=;
        b=HG3VbLLbJF7MlpqEE2yp5igZ2wkElNz8qAYOLBewRF8QXDCCJgX2lL7Y9xm3YBgN9q
         /iizgizvvdRRXUPz9QL8HsVEMEJQRO/kyhAdurmYCy+SWZ3fV6UVrOALglPLik8XAU6n
         4mohsM8yMUGlS7vuHlI7WhWVD8errca59nzYmFbHOT0TJ1cjGnWhtDFbqst3tZ8vZ/hl
         TfdaXXifZlOlUKn2MOdjgEVNJW7ol/q0OwLahgYXAApywOMlCEmpRgAK45k4O2kjMiOS
         suYrf1LbLPOk1qFwBg1b6VPsu7sgvezSYgQ1Zf4PJnQHX741tY27mzOZff+CkXD8dMCg
         EiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpQs5XKfADQ3M323QC+V1TXEIIA5lhyXKfjNkqvRn0g=;
        b=MxcSO22yYMZIu2/LnnsDiqdBxhKyND8pYNKoDJ/bVWsHa4NPhxyl/Rho4khPIcxcnf
         qgJ94w/30TwwjiMo0bJB7qsaP4ujYHVBCXSU/tiwRze1maa4Li5tx94OionXPL3jPo4r
         3j2oPyVXCZDvN1EQwmSqvZwFsHsDChdQr63r4CeTIJee0LIwU726uCgzcZQbwVAztswe
         YjhkXVTJegxNL22N/cG1Mcc+0KWEsFVz9vYqq35jGSrrXcL9WJqbYNMW/7hd1ZBLjWZX
         fplgRCLn8xQ6+i29AwHlr9nXkXKkol5nYA1GflF2qjQv7g2gjAWZWvgk6eIQ8aQ3hKwK
         ekyQ==
X-Gm-Message-State: AGi0PuaCmtoQSWTFhMWO3SodCVcGmGKIRrYVSJ4fgcctdTxOubmWW/8m
        SZU3cEahK98Jpj6yZcGfCe16zrpZKeHvgy9aozDGYQ==
X-Google-Smtp-Source: APiQypKqSMWCwV9R0iYXb1MgNOBiE1MZj7Dm2Ukyd/nXBMyXUdVdpxFFBvATWg31HGDznrA3yovstE9C4phqMq6ntqU=
X-Received: by 2002:a92:1bc1:: with SMTP id f62mr7995520ill.127.1588013817707;
 Mon, 27 Apr 2020 11:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
In-Reply-To: <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
From:   Andreas Smas <andreas@lonelycoder.com>
Date:   Mon, 27 Apr 2020 11:56:46 -0700
Message-ID: <CAObFT-TSJTdaDMBNCtZphVEDrZU++CYfXz+nuhf72o9VyC=xZw@mail.gmail.com>
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 25, 2020 at 1:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> It was originally disabled because of a security issue, but I do think
> it's safe to enable again.
>
> Adding the io-uring list and Jann as well, leaving patch intact below.
>

Ok thanks,

Should I prepare a new real patch or will this trickle on?
