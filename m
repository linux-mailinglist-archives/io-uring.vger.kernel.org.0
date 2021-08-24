Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546563F6BC5
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 00:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhHXWoZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 18:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhHXWoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 18:44:25 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27247C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 15:43:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a25so20792270ejv.6
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 15:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=/7YU6iKZE0eObL7ThkS4XqtFE0+bighBGrbHPHFQeyM=;
        b=Fias3YN/QDoYpLfnEl95+Vidv4wdOFzMm+zfrYsSmTezSBsG8XaKHXtyW+wB25KAMk
         Iu1p7bguxFo22UawqdLkgpT3B1MfQ4bG8mMA4UD/Y6zhtDxVbRGs41eiKXsKnheUsljD
         2cLpWeiSUHc2mLA+FSK0IABSsjKtxD3NesCw/QdqoOHPY2mjLkYJhDJESUOtem9SJbWy
         1WiEWtajSAunJOxOZ8EwXv520BIDvp9ju900jialv3jgR9/pb4UTRlepgw2qtzhgUtyO
         GTYGSdaJa5E+r1mrDxIOIbs3LxLe7MHaOiFrVfkafGiAzxUhBZsb9+h3/Khcfjsm0bo9
         mKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/7YU6iKZE0eObL7ThkS4XqtFE0+bighBGrbHPHFQeyM=;
        b=IHM32LPUkqF8t5nAVx8W8eJ4UMom94j79CIBvvV5z8bxCRISwISkHHCR1HSAFRzASp
         HhIc6NlzrlfpcK+IZ1bL8Gtk6xtFVp4l6j/VWlJaH71vmeIvEVddCybtrgokxq/j4QWx
         8E6fe7al0oVJ/c4qbmZc5OIdlf0fbIqckmf9Jw2cTESbfHOvdV+oeIccfCTbtoydw1To
         f6UXEAmWKlKvBKjainIriLx0vMvEr4QzT8+bcN+v/rQ/ExT7LTT/6tiha+PhK3G61oCZ
         eBmBYq8rc4aeLcpReVQu0fOlIkf2Q8af+LPyzvOl70rcFuStwBKMDZpQiu6aL2GfHAMc
         6/zA==
X-Gm-Message-State: AOAM532gaLN9HBX4tkruBystClYtF2HfkOYycRLGSpWfElDSDpVAAY/Q
        DVhnxJhzaNQos6LtoLErDhB0iRcE8HBnwempT+xJZRvz52rsQhVwSDY=
X-Google-Smtp-Source: ABdhPJwf67Mha5qjLb+U0zIDNyJ+kbkeLM5kYxCixsZlORYIT8Z6I4SVo1wrrU0ysb6Kl17NWFMKPuJAlSmGsuWQTDg=
X-Received: by 2002:a17:906:5d6:: with SMTP id t22mr42268441ejt.98.1629845018560;
 Tue, 24 Aug 2021 15:43:38 -0700 (PDT)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 24 Aug 2021 23:43:27 +0100
Message-ID: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
Subject: io_uring_prep_timeout_update on linked timeouts
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

we're able to update timeouts with io_uring_prep_timeout_update
without having to cancel
and resubmit, has it ever been considered adding this ability to
linked timeouts?

maybe io_uring_prep_timeout_update could be extended to seamlessly
operate on linked
timeouts as well without any api change? i assume this isn't possible
currently because
there are no tests displaying it in liburing.
