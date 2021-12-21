Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0847C765
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 20:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241763AbhLUTS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 14:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241762AbhLUTS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 14:18:26 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F75C061574
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 11:18:25 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b13so27455255edd.8
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 11:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRiTz8bhQursjP/dTzeG8mCouhMPco8A9ASNz/ffLTk=;
        b=B8V5Wn6N6Zse7OjKgFG0n1vPlbpGwU+uTTSxI53sbD/engpJYQQ4L9W3yCr8LhIIxS
         KhnF3JbhL7ny3lPBoneIi8nvGgIq3g3rISma8RwYPOJEAlrY2Sn9/sl38eWZFfo3EqVM
         4/Opuv9RuJ2bZNzx4/YlvodiF9NjGzi3dwv5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRiTz8bhQursjP/dTzeG8mCouhMPco8A9ASNz/ffLTk=;
        b=15ab7K/7rtA5Lr6CgvnU3ZqfJD3G471Kj+cDYfyV+VFjpYWkNKM3pfkLGptODpt2Ry
         dHCtRy/fODEvvPpxLFNwQJ0B8DhSAMHOtqDq2ArLcPb6TURKmbbXAbgoABVpOSrswEl1
         yPQGc1GVVi58uWtzzKXlf2kfbXZuX7X1CIq2RrGPN9nmzeET+AoWTroMZf8GkMs3zXok
         NZSJepDFd2x0wrIe8KFlK18F8APwhfO6z7S7k/KZUPr+Ul6Tbog5Q36HaLfryCCPZcpF
         5pyEQ8zLX/pOgNGlUl9zE1/Z+WMFDuHcS3325LtoGqp5N7iFe/imqxfkimcmh7dWUonp
         upXg==
X-Gm-Message-State: AOAM531HVD5LkEiAEjSJqp9tc941CAT1BpQ8BdwIUMtgZlfX5T5sdR+r
        a1s+nPrexBEF5lg9FP7BTHlmcKAA0R6Nk7fULHk=
X-Google-Smtp-Source: ABdhPJy7YoFWxI57GJ/Juzn0Cpt+H/PfOksVmIB8RssnCQ4ecSc6pD4v7uUAsfGvnZlPO3ZMvb7K8Q==
X-Received: by 2002:a17:907:76d4:: with SMTP id kf20mr3956178ejc.44.1640114304300;
        Tue, 21 Dec 2021 11:18:24 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id bx6sm3304198edb.78.2021.12.21.11.18.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 11:18:23 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id y83-20020a1c7d56000000b003456dfe7c5cso2420259wmc.1
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 11:18:23 -0800 (PST)
X-Received: by 2002:a05:600c:1e01:: with SMTP id ay1mr4001998wmb.152.1640114303620;
 Tue, 21 Dec 2021 11:18:23 -0800 (PST)
MIME-Version: 1.0
References: <20211221164959.174480-1-shr@fb.com> <20211221164959.174480-4-shr@fb.com>
 <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com> <a30eda4f-ebf2-5e46-d980-cd9d46d83e60@fb.com>
In-Reply-To: <a30eda4f-ebf2-5e46-d980-cd9d46d83e60@fb.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Dec 2021 11:18:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjqUaF=Vj9f44m7SNxhANwoTCnukm6+HqWnbhhr2KHRsg@mail.gmail.com>
Message-ID: <CAHk-=wjqUaF=Vj9f44m7SNxhANwoTCnukm6+HqWnbhhr2KHRsg@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] fs: split off do_getxattr from getxattr
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 11:15 AM Stefan Roesch <shr@fb.com> wrote:
>
> Linus, if we remove the constness, then we either need to cast away the constness (the system call
> is defined as const) or change the definition of the system call.

You could also do it as

        union {
                const void __user *setxattr_value;
                void __user *getxattr_value;
        };

if you wanted to..

                 Linus
