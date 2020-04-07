Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0141A1327
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgDGRws (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 13:52:48 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40340 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGRwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 13:52:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id j17so3078396lfe.7
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 10:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5c+CsqAqLUBl/bSdRYKSg7oIgz5eOMt76Z/m3+AosYI=;
        b=NIXY8CXPCgS3KfqaSC0tW1TS2ToYNRp1TMzg+k5lBuY7c/LgDUW5IKTXbE5KKPCAtS
         IU+2Qo7ejuH4WA5khGOsaMgJYnL1Iemy3R+CRRp094dTkaot6Dxc+vDS4UzcCqeaXaor
         dW71E4g18Rlmds67pAE8YJfRT0B4rjHUtcl0nYuTzJr9rXqLewRGdmaf3+K0OjKsSbeT
         /jiuynlteoYoJ/BAmGOS1zn5ogcmX9bfjKJXe4vah7+kagr4fP7oQbQtGAqGKlPUr4vt
         /8dcBV8nE+fGD2vAuJSmzc4apQD+QVByUM2N/aKwiNf7k9dCpMEYZxxDW/sixcGmWqwv
         QeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5c+CsqAqLUBl/bSdRYKSg7oIgz5eOMt76Z/m3+AosYI=;
        b=psbFtQa+7i3l34XNiAc8R7ECgR+rKF4QDSCybnjXHCGxSVPmi4dH3blU7jn9RESjbD
         BIIEIhzn78crIGmlt6jtn0MrGwysnEtNKheoPiMfOXFnEAaV9UZGCX2eXiuWnAbmUtOC
         y5rxcXJusQONsMc8rrDrhvEbDPz//4eByLiFtgU/QmL59XUhXaQsvYSo+YFDocbQNIEm
         trklK+IuPrGs4eQ8wHFlmI2tlAzLBJep8Wk/UgR4FIArdtBOQ0WtbHr9siOAbsqWSi2l
         ZG4zgOd42+dl9RN4dozaf6Cv0MWbQOzG06LaTKACk95qP0rWa6dEmNR4GfV0j5H+FJqb
         9WxA==
X-Gm-Message-State: AGi0PuYzHeoxGYuSU0J2zGKg6aMg2uzVKBi9mU2L3jP2qjHHMTEsFzNK
        QoLhR1cckP3GOuAUGw1ADbGWr2WB6qe51si2Z4PcFw==
X-Google-Smtp-Source: APiQypLwZb6L0pTn4O4Fua6Ds4vjJLPIXW1vpafkg81c5kdd35NLT6blZrvCprZjgvRmsvA9v0XcX48WX2DjFG2Ubn4=
X-Received: by 2002:a19:3f89:: with SMTP id m131mr2147980lfa.141.1586281965571;
 Tue, 07 Apr 2020 10:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200407160258.933-1-axboe@kernel.dk> <20200407160258.933-2-axboe@kernel.dk>
In-Reply-To: <20200407160258.933-2-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 7 Apr 2020 19:52:19 +0200
Message-ID: <CAG48ez3H+xXMbEVvG5gy0r4BjEY2RfkOxn1yN9Dmhb8n97m-qA@mail.gmail.com>
Subject: Re: [PATCH 1/4] task_work: add task_work_pending() helper
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 7, 2020 at 6:03 PM Jens Axboe <axboe@kernel.dk> wrote:
> Various callsites currently check current->task_works != NULL to know
> when to run work. Add a helper that we use internally for that. This is
> in preparation for also not running if exit queue has been queued.
[...]
> +static inline bool task_work_pending(void)
> +{
> +       return current->task_works;
> +}

I think this should be using READ_ONCE().
