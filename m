Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D592549D4D
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 21:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbiFMTT4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350674AbiFMTTL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 15:19:11 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C475527FE8
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 10:16:19 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id u2so4746559iln.2
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 10:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=WK6OLngTEGMQZnXAmgyK8gksEaTtYBKX+MRhgq0dtFw=;
        b=Nzz1+tPv5melE6UbBC+sOH/ib1hKvPctkfev3+WLu7gJrFS+lJUdpfpxEFvYwgD5c/
         b680T3FvM5wSCc86DHPvF8yAJKYi7kfFo8qOYvy4KF3/UY6JZgTI4bE48iGZu/O6uVhI
         abQbL3dFFAPSn7CSTSE3iBVfeKetAvsWFbRz0wuY/5h/hKtCiMjJCktS9Eh8cKZyzjk8
         q31fFUk4cLRvcdZJ7i5AUwT+kdso5f47/8IWOsl5FOwrEqsOdsQW21zyVCl1sIYrIDZH
         mRqdnm6iLwTC5jexLECioOUBcAnjoh2Whj1H/ShHO/3a+f11aneHl+KGZhMnumuXqOnO
         6Hqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=WK6OLngTEGMQZnXAmgyK8gksEaTtYBKX+MRhgq0dtFw=;
        b=gssr7RGtHCi22dXTsUoouE/V58l7QvV4LsJf763CKnG0tEJoiolW9w5OAJQUf1Yxcj
         8sM3IKh3RJis5+NxnQL0MeDRlf0n+aYfS8ETtoi7KqtHYVmxipPFqXnuRKy9mO2h8A18
         JqCGrCOf0aT2zfMdNigGGECjy4PQb51Mz4Z1DJlfCZTx8XjuemZODTRVrVuj8XYKt0zn
         TmOTJApPUArW8vEdkGn6FClScrIOS90fQOaEixMn7igKsYUhCTWdRMp+R/Z8veLCXhjD
         s3dnaiKBDeWIOcflqqjP+q9R9VPRPVE3535NW3zU0TNvGyIjgwUSHewg88XLFGs5pJq+
         5eAw==
X-Gm-Message-State: AJIora+gPlv/ecN61ov2+nwOVfYrdiU+xXVrUsy28C1Owp7wumslDqYv
        LefvxszNEoWKQClJRIFCHtn+3zfAZ+br9DxtSkA=
X-Google-Smtp-Source: AGRyM1uOe0smkqtBabtgPkMMpx/Q+wBI7s9Dle3NCqyF8zLzQmh6G0hH+sglH/YP91rx6pwicRhBOYy8/IBrJHWhLjM=
X-Received: by 2002:a05:6e02:16cc:b0:2d1:9a4c:db79 with SMTP id
 12-20020a056e0216cc00b002d19a4cdb79mr503705ilx.175.1655140579241; Mon, 13 Jun
 2022 10:16:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a92:d350:0:0:0:0:0 with HTTP; Mon, 13 Jun 2022 10:16:19
 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   sgt kayla manthey <sagancire@gmail.com>
Date:   Mon, 13 Jun 2022 11:16:19 -0600
Message-ID: <CANWOAsxn=BgJ6tcvT+DxmmUpVuiZa9ZK+i+wztdjg9S3JSpkyg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Greetings,
Please did you receive my previous message? Write me back
