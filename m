Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E647430BFB
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbhJQUYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 16:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242552AbhJQUYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 16:24:25 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153B6C06161C
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:22:15 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r184so4955383ybc.10
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=aPywRCOrNC/U1Jl+sch6wVi0r1rbmSEIrZ4LoynUa4nBDDPZsXgzsV/5vgH1FaiQbz
         zrl2bpFL9LTQM039OXgRUsvG//Nrjv4ab6A0xdnKgGK2lQONpIPYSd7gSL63qxK9Rwy8
         xo+S4oV+3z+1+IBJ7E7xkSJ5UPYHgrT3+bXc0FOp9I2pRQRUWlwEmGgLvFCh2lrUH/JL
         DFMZv12cCEQOwZHjH2KDjOZl8y0lI5rYxEYBf2rULfXeNBfZ1LDRojwevLKExfSDPldH
         Ba2QkoC4M61sCavb7/hADM0HKD22rZSsD5VilSWUwOKGkvIEJZ3O3fdxmvzq2msvAXSa
         eGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=SuP3m5G5n/20Ceh7LPFcHq3RU8b1OawWkkzar32MmgmbYfavr2SWAIFzz1JO5CacGG
         Wq4IjHiJlR6duqjo1zeGBtpHUH6LwanDZ7+okOy52oIfpYB73KvqO1txcW/kPrn9tO1H
         j0Gn4WKeXU/TnkD0oUuh2glsI9Yi/VvcwXHt/X+fUu9gr6uWQl3K3TFENg04T/SGhk1c
         ipWXPAkmdIZdgRxntiYMfOsaDXJhor3aAXEfTfLszZpXxya0YMF3Kc2S6sxgySLenWzV
         tWVRNNBg5+OpqinhoRmJXB/fUlX3BH+gvajEGsofZ3phyLnJUAPOWpGoO/ayEWeVt9Wr
         x6GA==
X-Gm-Message-State: AOAM530I9C/KpgOHolLopdi9wyd0GeiOZnk2kmPrsg4vA5Jr5BROlBTl
        9dml+GscbGgUHIbOLmdZyPWCqspJ8OhqfNVebag=
X-Google-Smtp-Source: ABdhPJyJL5lydUZOweS5kdIp8mZ4M+yyuIBCuTrF6RtDD4H/PpRRecNbhuSl5FVUzRDlkE09ImnjtuqwfbYpsQpetFc=
X-Received: by 2002:a25:698f:: with SMTP id e137mr25124400ybc.323.1634502133965;
 Sun, 17 Oct 2021 13:22:13 -0700 (PDT)
MIME-Version: 1.0
Sender: miraclegod104@gmail.com
Received: by 2002:a05:7010:a214:b0:198:7b1c:6d with HTTP; Sun, 17 Oct 2021
 13:22:13 -0700 (PDT)
In-Reply-To: <CAAodT-6_adJQrsGehWChTVUbQu8bSSZVkFkNPRZxt1oUmsRkfQ@mail.gmail.com>
References: <CAAodT-4Gyk6ZDNQmO6GT5b_WJUh8hZZKtW_+MozwJgkyhcQ+aA@mail.gmail.com>
 <CAAodT-4omMSmjUAiijs5a4tB4JRxQyL4XvRygfcLN1b0SiXYNA@mail.gmail.com>
 <CAAodT-5NT8Jj9BY8Y2NyMh-Epc-kghY2GWfOSPSBxFGQtY2goA@mail.gmail.com>
 <CAAodT-5-OGzvndDViWjRNG9-7RZgYcDAnHkv-f1-czx81bxWLw@mail.gmail.com>
 <CAAodT-7GBSx100X5y3H7+ghE7KvNH90EUG6b5NPH+MLN9Sms0Q@mail.gmail.com>
 <CAAodT-7z02J1YvSA_7_Lpu5Eb8n+PasckfKr-tNvT5yfKh7zAA@mail.gmail.com>
 <CAAodT-4WW1QAaJqausd_S3VHcq-JveJwW5TecwQ8AB5HjK1F=g@mail.gmail.com>
 <CAAodT-4mNUjyr2G3b+NKDMUmDsm0vmbV6x2pz07QUk+kSEBOWw@mail.gmail.com>
 <CAAodT-65q+QwQ7hKJ3Yp-XJgKCA87dw1jHNdJTD6x7y7-pBcTA@mail.gmail.com>
 <CAAodT-5fbNX4ofL_x3Ht+jw2fb1hqD4pnpnFLmdR9FpGGHmFNA@mail.gmail.com>
 <CAAodT-6=LmFtsUxb7jNX8_H33R2dGSW5oZfNy6gT1Gw2_L-F3Q@mail.gmail.com>
 <CAAodT-5bMnLggUon=XFTxha6WpzCmonQ8ooeaz73Q2OoT1v-8w@mail.gmail.com>
 <CAAodT-4mRCZH3xk92xScU92RRZNTXRjHS7At_xwBDrtj1B-U4g@mail.gmail.com>
 <CAAodT-6XMg=5V9TnoWCWnE+nLB5kzVz5TbzA3sLZ87qteuQ8jg@mail.gmail.com>
 <CAAodT-45r+fbwZmNC2qKEZ-j_5e1HdGHt+Lgti43ggAWU0zHEA@mail.gmail.com>
 <CAAodT-5P+nD5T+HmH+N=ty6z4pkrnPge+p_Nux2=uuUWtv=WYA@mail.gmail.com>
 <CAAodT-6udNFh8TiCXsUWnSMQbaOO471bJtZH73_U3+ur6K=dnw@mail.gmail.com>
 <CAAodT-7HcCS-JD-KJOO2PCxKcdrvrrNcciay3qqmK8HMitTrqw@mail.gmail.com>
 <CAAodT-6X1HnqZnRnTAZQ7UFmtNootKX60iPxgTP4Q_onOgsGsg@mail.gmail.com>
 <CAAodT-6uNOvTxCUhQHEUYKBnUK2DVXP_DyU31Jhb3B6X=dCgoQ@mail.gmail.com>
 <CAAodT-5UoPHq5QO6oWi4kzBXcdFFG2+gV1dcCHnS1prdw9gy-Q@mail.gmail.com>
 <CAAodT-71xFkW7d2z+sd1ivFTvTOx-rBAvqc59iMsbngMNvW8Kg@mail.gmail.com>
 <CAAodT-6RrQ=ZG-neBVmA6ov9CxDBuhFN3f7axN0eh6qUggH4xQ@mail.gmail.com>
 <CAAodT-4wvtVwz0_GRzv0QYgVbp9vmxV4Q9U=0uECVFjU-6=AjQ@mail.gmail.com>
 <CAAodT-4efketfOepm4R_3qHiq6iCQ8ahv0DPWYP-5hn34=d+FQ@mail.gmail.com>
 <CAAodT-55hTPYo4LWZwVBKPzsOeHUMkhL2qKurE2kGgYuaBRMFA@mail.gmail.com>
 <CAAodT-45ZoehbKTe6=J8-cehWvszvesW9QRZ6Yo1FWoiAdwuRQ@mail.gmail.com>
 <CAAodT-4QZi12yay0Ugvioq=yO4KL6bqg73u2k6bQhzADX-FWXg@mail.gmail.com>
 <CAAodT-7UquB4Pou39f_gU+-w=H5-XfX7d=n4uvR0H-QoV1ceWg@mail.gmail.com>
 <CAAodT-48XQDpppeQDx+YLnLS-pYO5AJfOc6apyJ-bqATJnEnzA@mail.gmail.com>
 <CAAodT-5JCGgikhQouW0pThyMtbtVbAjjkja6KFfS6+rNG1PBxA@mail.gmail.com>
 <CAAodT-5CJ=9ai40X1ARQS5dhpZbce2UyKGfrtBrN1wg5H40XWQ@mail.gmail.com>
 <CAAodT-7mwnPbN-DvZWpSoAy1hjAYjDu+-NXaSArpHcQpRot=_A@mail.gmail.com>
 <CAAodT-4Edtz0yuAp8S4xKgHPARBd2PQPCk3FOvh2dnYsM+EQEQ@mail.gmail.com>
 <CAAodT-5byS1-3r45LqjjiSMzjxJuo7FiGPpTfDhv2Lh-2SHvSg@mail.gmail.com>
 <CAAodT-6LdNYE5Rb_NFvGFeugj+H35XfsnU991A_cAYR25gQwFg@mail.gmail.com> <CAAodT-6_adJQrsGehWChTVUbQu8bSSZVkFkNPRZxt1oUmsRkfQ@mail.gmail.com>
From:   "Mrs. Rose Guzman Donna" <ebubedikemplc@gmail.com>
Date:   Sun, 17 Oct 2021 20:22:13 +0000
X-Google-Sender-Auth: tOz2WK5WigRV7-4nBilF0R-yYo0
Message-ID: <CAAodT-4L=24os1pGA7cT+m2RaWErmB_YSzZyaKrv_jKaaV4suQ@mail.gmail.com>
Subject: Fwd: I want to open Charity Foundation in your country to help the
 poor (etc) on your behalf is OK? Mrs Rose from America
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


